class AppConfigModel{
  final int id;
  final int darkMode;
  final int editFontSize;
  final int fontSizeChange;


  AppConfigModel(
      this.id,
      this.darkMode,
      this.editFontSize,
      this.fontSizeChange,
      );

  AppConfigModel.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        darkMode = item["dark_mode"],
        editFontSize = item["edit_font_size"],
        fontSizeChange = item["font_size_change"];

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'dark_mode': darkMode,
      'edit_font_size': editFontSize,
      'font_size_change': fontSizeChange
    };
  }
}
