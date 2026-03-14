from typer.testing import CliRunner
from app.main import app

runner = CliRunner()


def test_hello():
    result = runner.invoke(app, ["hello", "--name", "test"])
    assert result.exit_code == 0
    assert "Hello, test!" in result.output
