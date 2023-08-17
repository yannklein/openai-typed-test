class GetAiResponseJob < ApplicationJob
  queue_as :default

  def perform(chat)
    @chat = chat
    call_openai(@chat)
  end

  private

  def call_openai(chat)
    message = Message.create(chat: chat, role: "assistant", content: "Thinking...")
    message.broadcast_created
    OpenAI::Client
    .new(access_token: ENV['OPENAI_API_KEY'])
      .chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: Message.for_openai(chat.messages),
          temperature: 0.1,
          stream: stream_proc(message)
        }
      )
  end

  def stream_proc(message)
    proc do |chunk, _bytesize|
      new_content = chunk.dig("choices", 0, "delta", "content")
      message.update(content: message.content + new_content) if new_content
      message.broadcast_updated
    end
  end
end
