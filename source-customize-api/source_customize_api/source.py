import logging
from typing import Any, List, Mapping, MutableMapping, Optional, Tuple, Iterable

import requests
from abc import ABC
from airbyte_cdk.models import Status
from airbyte_cdk.sources.abstract_source import AbstractSource
from airbyte_cdk.sources.streams import Stream
from airbyte_cdk.sources.streams.http import HttpStream
from airbyte_protocol.models import AirbyteConnectionStatus
headers = {"Content-Type": "application/json"}

class MyStream(HttpStream, ABC):
    primary_key = ""
    state_checkpoint_interval = 10000

    def __init__(self, url: str, token: str):
        super().__init__()
        self.url = url
        self.token = token
        self.state = {}

    @property
    def name(self) -> str:
        return "my_stream"

    def http_method(self) -> str:
        return "GET"

    def path(self, **kwargs) -> str:
        logging.info("==============path:" + self.url)
        return self.url

    def url_base(self) -> str:
        logging.info("==============url_base:" + self.url)
        return self.url

    def next_page_token(self, response: requests.Response) -> Optional[Mapping[str, Any]]:
        # The API response should contain a "page_token" key if there are more pages to retrieve.
        # In this example, we assume that the page token is a numeric value.
        data = response.json()
        if "page_token" in data:
            return {"page_token": data["page_token"]}
        else:
            return None

    def request_params(self, **kwargs) -> MutableMapping[str, Any]:
        # If the stream has a "page_token" key in its state, add it to the request parameters.
        params = {}
        if "page_token" in self.state:
            params["page_token"] = self.state["page_token"]
        return params

    def parse_response(self, response: requests.Response, **kwargs) -> List[Mapping]:
        # This method should return a list of records parsed from the API response.
        data = response.json()
        records = data.get("records")
        if not records:
            return []
        return records

    def get_updated_state(self, current_stream_state: MutableMapping[str, Any], latest_record: Mapping[str, Any]):
        return {"page_token": latest_record.get("page_token")}

    def stream_slices(self, stream_state: Optional[Mapping[str, Any]] = None, **kwargs) -> Iterable[Optional[Mapping[str, any]]]:
        page_token = stream_state.get("page_token") if stream_state else None
        return [{"page_token": page_token}]



class SourceCustomizeAPI(AbstractSource):
    def __init__(self):
        super().__init__()
        self.logger = logging.getLogger(__name__)

    def check_connection(self, logger: logging.Logger, config: dict) -> Tuple[bool, Any]:
        url = config.get("url")
        token = config.get("token")

        logger.info(f"Attempting to connect to API at {url}...")
        try:
            headers = {}
            if token:
                headers["Authorization"] = f"Bearer {token}"
            response = requests.get(url, headers=headers)
            response.raise_for_status()
            data = response.json()
            logger.info(f"Response from {url}: {data}")
            if data.get("status") == 0:
                return True, None
            else:
                return False, f"Unable to connect to URL: {data.get('message')}"
        except (requests.exceptions.RequestException, ValueError) as e:
            return False, f"Unable to connect to URL: {str(e)}"

    def streams(self, config: dict) -> List[Stream]:
        return [MyStream(url=config.get("url"), token=config.get("token"))]

    def check(self, logger: logging.Logger, config: dict) -> AirbyteConnectionStatus:
        try:
            status, error = self.check_connection(logger, config)
            logger.info(f"Check connection status: {status}")
            if status:
                logger.info(f"Check connection success")
                return AirbyteConnectionStatus(status=Status.SUCCEEDED)
            else:
                logger.error(f"Check connection error: {str(error)}")
                return AirbyteConnectionStatus(status=Status.FAILED)
        except Exception as e:
            logger.error(f"Check connection error: {str(e)}")
            return AirbyteConnectionStatus(status=Status.FAILED)
