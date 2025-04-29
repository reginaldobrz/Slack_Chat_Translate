const chatContainer = document.getElementById('chat-container');
const advisor = document.createElement('div');
advisor.id = 'new-advisor';
advisor.innerText = 'New Message recieved';
advisor.style.display = 'none';
advisor.style.cursor = 'pointer';
advisor.style.textAlign = 'center';
advisor.style.background = '#fffae6';
advisor.style.padding = '10px';
advisor.style.border = '1px solid #e0c97f';
advisor.style.margin = '10px 0';
advisor.style.borderRadius = '6px';
chatContainer.after(advisor);

advisor.addEventListener('click', () => {
  chatContainer.scrollTop = chatContainer.scrollHeight;
  advisor.style.display = 'none';
});

let lastQuantity = 0;

async function loadMessages() {
  try {
    const res = await fetch('/messages_json');
    const messages = await res.json();

    if (messages.length === lastQuantity) return;
    const wasAtTheEnd = chatContainer.scrollTop + chatContainer.clientHeight >= chatContainer.scrollHeight - 20;
    lastQuantity = messages.length;

    chatContainer.innerHTML = '';

    messages.forEach(msg => {
      const el = document.createElement('div');
      el.classList.add('message');
      el.classList.add(msg.origem === 'user' ? 'sent' : 'recieved');

      const userName = msg.user ? `<strong>${msg.user}</strong><br>` : '';
      const userNameBot = `<strong>Reginaldo Aguiar Bot</strong><br>`;


      el.innerHTML = `
        ${!userName ? userNameBot : userName}
        <div>Message: ${msg.original}</div>
        <small>${msg.origem === 'user' ? `Sent (in English): ${msg.translated}` : `Translated: ${msg.translated}`}</small>
      `;
      chatContainer.appendChild(el);
    });

    if (wasAtTheEnd) {
      chatContainer.scrollTop = chatContainer.scrollHeight;
      advisor.style.display = 'none';
    } else {
      showToast("New Message Recieved");
    }

  } catch (err) {
    console.error("Error to loading messages", err);
  }
}

document.getElementById('message-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const text = document.getElementById('text').value;

  try {
    const previewRes = await fetch('/send-preview', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ text })
    });

    const previewResult = await previewRes.json();

    if (previewResult.status === 'ok') {
      const confirmation = confirm(`Translation:\n\n${previewResult.translated}\n\nWhould you like to send this message?`);
      if (!confirmation) return;

      const sendRes = await fetch('/send', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ text })
      });

      const sendResult = await sendRes.json();
      if (sendResult.status === 'ok') {
        document.getElementById('text').value = '';
        await loadMessages();
      } else {
        alert("Error sending message: " + (sendResult.error || "Unmapped Error"));
      }

    } else {
      alert("Error while to obtaing the text message translation.");
    }
  } catch (err) {
    console.error("Error while sending confirmation message", err);
  }
});

function showToast(msg = "New Message Recieved") {
  const toast = document.getElementById('toast');
  toast.textContent = msg;
  toast.style.display = 'block';

  setTimeout(() => {
    toast.style.display = 'none';
  }, 3000);
}

setInterval(loadMessages, 3000);
loadMessages();