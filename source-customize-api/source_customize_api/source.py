import logging
from typing import Any, List, Mapping, MutableMapping, Optional, Tuple, Iterable

import requests
import json
from abc import ABC
from airbyte_cdk.models import Status
from airbyte_cdk.sources.abstract_source import AbstractSource
from airbyte_cdk.sources.streams import Stream
from airbyte_cdk.sources.streams.http import HttpStream
from airbyte_protocol.models import AirbyteConnectionStatus


class MyStream(HttpStream, ABC):
    primary_key = ""
    state_checkpoint_interval = 10000
    _http_method = "GET"

    def __init__(self, url: str, headers: dict, http_method: str = "GET"):
        super().__init__()
        self.url = url
        self.headers = headers
        logging.info("===================>method:" + self.url)
        logging.info("===================>method:" + http_method)
        logging.info("===================>method:" + str(self.headers))
        logging.info("===================>method:" + http_method)

        self._http_method = http_method.upper()
        logging.info("===================>method:" + self._http_method)
        self.state = {}

    @property
    def name(self) -> str:
        return "api_data"

    def http_method(self) -> str:
        return self._http_method

    def path(self, **kwargs) -> str:
        logging.info("==============path:" + self.url)
        return ""

    @property
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

    def request_headers(self, **kwargs) -> Mapping[str, Any]:
        return self.headers

    def parse_response(self, response: requests.Response, **kwargs) -> List[Mapping]:
        # This method should return a list of records parsed from the API response.
        data = response.json()
        records = data.get("data")
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
        self.http_method = None
        self.headers = None
        self.logger = logging.getLogger(__name__)

    def check_connection(self, logger: logging.Logger, config: dict) -> Tuple[bool, Any]:
        url = config.get("url")
        http_method = config.get("http_method")
        headers_str = config.get("headers", "")
        if headers_str:
            try:
                self.headers = json.loads(headers_str)
            except json.JSONDecodeError:
                logger.error("Headers is not valid JSON")
                return False, "Headers is not valid JSON"

        logger.info(f"Attempting to connect to API at {url}...")
        try:
            if http_method.lower() not in ["get", "post", "put", "delete"]:
                raise ValueError(f"Invalid HTTP method: {http_method}")
            if http_method.lower() == "post":
                response = requests.post(url, headers=self.headers)
            elif http_method.lower() == "put":
                response = requests.put(url, headers=self.headers)
            elif http_method.lower() == "delete":
                response = requests.delete(url, headers=self.headers)
            else:
                response = requests.get(url, headers=self.headers)
            response.raise_for_status()
            data = response.json()
            self.http_method = http_method
            logger.info(f"Response from {http_method} : {url}: {data}")
            if data.get("status") == 0:
                return True, None
            else:
                return False, f"Unable to connect to URL: {data.get('message')}"
        except (requests.exceptions.RequestException, ValueError) as e:
            return False, f"Unable to connect to URL: {str(e)}"

    def streams(self, config: dict) -> List[Stream]:
        headers = ""
        headers_str = config.get("headers", "")
        if headers_str:
            headers = json.loads(headers_str)
        http_method = config.get("http_method")
        return [MyStream(url=config.get("url"), headers=headers, http_method=http_method)]

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
