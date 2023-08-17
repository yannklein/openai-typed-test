import { Controller } from '@hotwired/stimulus';
import { createConsumer } from '@rails/actioncable';

export default class extends Controller {
  static values = { chatId: Number };
  static targets = ['messages'];

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: 'ChatroomChannel', id: this.chatIdValue },
      { received: this.#handleMessage.bind(this) },
    );
  }

  #handleMessage(data) {
    if (data.update === false) {
      this.messagesTarget.insertAdjacentHTML('beforeend', data.partial)
    } else {
      this.messagesTarget.querySelector(`#message_${data.message_id}_messages`).outerHTML =  data.partial
    }
  }
}
