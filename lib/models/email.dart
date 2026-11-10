/// A simple email model.
class Email {
  final int id;
  final String sender;
  final String subject;
  final String preview;

  const Email(this.id, this.sender, this.subject, this.preview);
}
