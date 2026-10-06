import os
import json
import importlib
from unittest.mock import patch, MagicMock

os.environ.setdefault("AWS_DEFAULT_REGION", "eu-north-1")


def test_returns_the_new_count():
    fake_dynamodb = MagicMock()
    fake_dynamodb.update_item.return_value = {"Attributes": {"count": {"N": "5"}}}

    with patch("boto3.client", return_value=fake_dynamodb):
        import lambda_function
        importlib.reload(lambda_function)
        result = lambda_function.lambda_handler({}, None)

    assert result["statusCode"] == 200
    assert json.loads(result["body"]) == {"count": 5}
    fake_dynamodb.update_item.assert_called_once()
