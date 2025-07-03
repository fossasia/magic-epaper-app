class FilterUtils {
  static String getFilterName(Map<String, dynamic>? metadata) {
    if (metadata == null || !metadata.containsKey('filter')) {
      return 'None';
    }

    final filterName = metadata['filter'] as String?;
    if (filterName == null || filterName.isEmpty) {
      return 'None';
    }

    return filterName;
  }
}
