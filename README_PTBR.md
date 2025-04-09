# Slack Chat Translator (Ruby + Sinatra)

Este projeto é uma aplicação web simples em Ruby (sem Rails), que permite traduzir mensagens entre português e inglês em tempo real em um canal do Slack, com interface web e integração com um LLM (como LibreTranslate ou OpenAI).

---

## ✨ Funcionalidades

- Interface estilo chat (estática, sem React)
- Tradução automática entre 🇧🇷 Português ⇄ 🇺🇸 Inglês
- Integração com Slack (envio e recebimento de mensagens)
- Visualização web atualizada com polling a cada 3 segundos
- Confirmação de tradução antes de envio
- Exposição via Cloudflare Tunnel

---

## 📦 Pré-requisitos

- Ruby `>= 3.0` (testado em 3.4.2)
- Bundler (`gem install bundler`)
- Conta no [Slack API](https://api.slack.com/)
- Chave da API de tradução:
  - [LibreTranslate](https://libretranslate.com/) (grátis)
  - ou [OpenAI API](https://platform.openai.com/) (pago)

---

## 🚀 Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/slack-chat-translator.git
cd slack-chat-translator

# Instale as dependências
bundle install

# Crie o arquivo .env com suas chaves
cp .env.example .env

```
---

## 🐳 Rodando o LibreTranslate localmente (Docker)

Você pode executar o seu próprio servidor de tradução usando o LibreTranslate localmente com Docker:

### 1. Suba o container:

```bash
docker run -d -p 5000:5000 libretranslate/libretranslate
```

Configure a URL no .env:

```bash
LIBRETRANSLATE_URL=http://localhost:5000/translate
```
Verifique se está funcionando:
Acesse no navegador:

```bash
http://localhost:5000
```
Você verá a interface da API REST do LibreTranslate.

---

## ▶️ Executando a aplicação
```bash
ruby app.rb
```
Acesse: http://localhost:4567

---

## 🌐 [Opção 1]Tornar público com Cloudflare Tunnel

```bash
cloudflared tunnel --url http://localhost:4567
```

O terminal mostrará um link público do tipo:

```bash
https://exemplo-aleatorio.trycloudflare.com
```

Use este link para configurar o Slack Events URL:

```bash
https://seu-tunel.trycloudflare.com/slack/events
```
---

## 🌐 [Opcao 2]Tornar público com Ngrok Tunnel

Com o agent do ngrok instalado, vamos rodar o seguinte comando

```bash
npx ngrok start --all --config ./ngrok.yml
```

O terminal mostrará dois forwarding links públicos , um para a porta :5000 (libretranslate) e um para a porta :4567 (Aplicacao no sinatra):

- Agora basta add a URL que ele foneceu para a porta :5000 no seu arquivo .env para o param 'LIBRETRANSLATE_URL'

- Já para a URL referente a porta :4567 sera utilizada para add na configuração do seu slack.Acessando No seguinte endereço :

```bash
https://api.slack.com/apps
```
Você vai criar um app novo que sera seu bot chat, nas configurações acesse a aba 'EventSubscription', ative a funcionalidade e no campo 'Request URL' adicione a URL que o NGROK gerou para a porta :4567 com o sufixo '/slack/events' e salve.

```bash
https://URLNGROK/slack/events
```
Feito isso , seu chat bot estara pronto para escutar os eventos da sua aplicação.

## 🛠️ Desenvolvimento
- As mensagens ficam salvas no arquivo messages.json

- A UI é construída com HTML+ERB+CSS puro

- Polling a cada 3s carrega mensagens novas

- O botão "Send" exibe uma tradução antes de enviar

- Toast de nova mensagem aparece se o usuário não estiver no final do chat


---

## 🧪 Testando
- Envie uma mensagem na interface

- Verifique se foi enviada para o Slack (traduzida)

- Responda no Slack (em inglês) e veja ela aparecer na interface (traduzida para português)

---

## 📂 Estrutura

```bash
app/
  controllers/
  services/
  views/
  public/
app.rb
messages.json
.env
Gemfile
```
