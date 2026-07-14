sealed class ItemsEvent {
  const ItemsEvent();
}

final class LoadTheory extends ItemsEvent {
  final String itemsId;
  const LoadTheory(this.itemsId);
}

final class LoadPractice extends ItemsEvent {
  final String itemsId;
  const LoadPractice(this.itemsId);
}

final class LoadPreviews extends ItemsEvent {
  const LoadPreviews();
}