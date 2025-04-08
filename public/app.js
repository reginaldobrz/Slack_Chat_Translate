const chatContainer = document.getElementById('chat-container');

// Cria o aviso de nova mensagem (fora do loop)
const aviso = document.createElement('div');
aviso.id = 'novo-aviso';
aviso.innerText = 'Nova mensagem recebida';
aviso.style.display = 'none';
aviso.style.cursor = 'pointer';
aviso.style.textAlign = 'center';
aviso.style.background = '#fffae6';
aviso.style.padding = '10px';
aviso.style.border = '1px solid #e0c97f';
aviso.style.margin = '10px 0';
aviso.style.borderRadius = '6px';
chatContainer.after(aviso);

aviso.addEventListener('click', () => {
  chatContainer.scrollTop = chatContainer.scrollHeight;
  aviso.style.display = 'none';
});

let ultimaQuantidade = 0;

async function carregarMensagens() {
  try {
    const res = await fetch('/mensagens_json');
    const mensagens = await res.json();

    if (mensagens.length === ultimaQuantidade) return;
    const estavaNoFinal = chatContainer.scrollTop + chatContainer.clientHeight >= chatContainer.scrollHeight - 20;
    ultimaQuantidade = mensagens.length;

    chatContainer.innerHTML = '';

    mensagens.forEach(msg => {
      const el = document.createElement('div');
      el.classList.add('mensagem');
      el.classList.add(msg.origem === 'usuario' ? 'enviada' : 'recebida');

      el.innerHTML = `
        <div>${msg.original}</div>
        <small>${msg.origem === 'usuario' ? `Sent (in English): ${msg.translated}` : `Translated: ${msg.translated}`}</small>
      `;
      chatContainer.appendChild(el);
    });

    if (estavaNoFinal) {
      chatContainer.scrollTop = chatContainer.scrollHeight;
      aviso.style.display = 'none';
    } else {
      mostrarToast("Nova mensagem recebida");
    }

  } catch (err) {
    console.error("Error to loading messages", err);
  }
}

document.getElementById('mensagem-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const texto = document.getElementById('texto').value;

  try {
    const previewRes = await fetch('/enviar-preview', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ texto })
    });

    const previewResult = await previewRes.json();

    if (previewResult.status === 'ok') {
      const confirmacao = confirm(`Translation:\n\n${previewResult.translated}\n\nWhould you like to send this message?`);
      if (!confirmacao) return;

      const envioRes = await fetch('/enviar', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ texto })
      });

      const envioResult = await envioRes.json();
      if (envioResult.status === 'ok') {
        document.getElementById('texto').value = '';
        await carregarMensagens();
      } else {
        alert("Error sending message: " + (envioResult.error || "Unmapped Error"));
      }

    } else {
      alert("Error while to obtaing the text message translation.");
    }
  } catch (err) {
    console.error("Error while sending confirmation message", err);
  }
});


function mostrarToast(msg = "Nova mensagem recebida") {
  const toast = document.getElementById('toast');
  toast.textContent = msg;
  toast.style.display = 'block';

  setTimeout(() => {
    toast.style.display = 'none';
  }, 3000);
}



setInterval(carregarMensagens, 3000);
carregarMensagens();
