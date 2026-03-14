import typer
from rich.console import Console

app = typer.Typer(help="CLI tool.")
console = Console()


@app.command()
def hello(name: str = typer.Option("world", help="Who to greet")):
    """Say hello."""
    console.print(f"[bold green]Hello, {name}![/bold green]")


@app.command()
def run():
    """Main command — implement your logic here."""
    console.print("[bold]Running...[/bold]")


if __name__ == "__main__":
    app()
