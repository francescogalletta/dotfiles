export default async function Home() {
  const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

  let message = "Loading...";
  try {
    const res = await fetch(`${apiUrl}/api/hello`, { cache: "no-store" });
    const data = await res.json();
    message = data.message;
  } catch {
    message = "Could not reach backend";
  }

  return (
    <main style={{ padding: "2rem", fontFamily: "sans-serif" }}>
      <h1>Web App</h1>
      <p>Backend says: <strong>{message}</strong></p>
    </main>
  );
}
