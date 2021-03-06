/*This file is part of Medito App.

Medito App is free software: you can redistribute it and/or modify
it under the terms of the Affero GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Medito App is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
Affero GNU General Public License for more details.

You should have received a copy of the Affero GNU General Public License
along with Medito App. If not, see <https://www.gnu.org/licenses/>.*/

class ListItem {
  String thumbnail;
  String title;
  String id;
  String description = '';
  String contentText;
  ListItemType type;
  FileType fileType;
  String url;
  String parentId;

  ListItem(this.title, this.id, this.type,
      {this.description,
      this.fileType,
      this.url,
      this.parentId,
      this.thumbnail,
      this.contentText});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['thumbnail'] = thumbnail;
    data['id'] = id;
    data['description'] = description;
    data['contentText'] = contentText;
    data['type'] = type.index;
    data['fileType'] = fileType.index;
    data['url'] = url;
    data['title'] = title;
    data['parentId'] = parentId;
    return data;
  }

  factory ListItem.fromJson(Map<String, dynamic> parsedJson) {
    return ListItem(parsedJson['title'] ?? '', parsedJson['id'] ?? '',
        ListItemType.values[parsedJson['type'] ?? 0],
        thumbnail: parsedJson['thumbnail'] ?? '',
        description: parsedJson['description'] ?? '',
        contentText: parsedJson['contentText'] ?? '',
        fileType: FileType.values[parsedJson['fileType'] ?? 0],
        url: parsedJson['url'] ?? '',
        parentId: parsedJson['parentId'] ?? '');
  }
}

enum ListItemType { folder, file, illustration }
enum FileType { audio, text, both, audiosetdaily, audiosethourly }
