document.getElementById("loadMessage").addEventListener("click", async () => {
  const messageElement = document.getElementById("message");

  try {
    messageElement.textContent = "APIを呼び出し中...";

    const response = await fetch("/api/message");

    if (!response.ok) {
      throw new Error(`API request failed: ${response.status}`);
    }

    const data = await response.json();

    messageElement.textContent = data.message;
  } catch (error) {
    console.error(error);
    messageElement.textContent = "API呼び出しに失敗しました。";
  }
});