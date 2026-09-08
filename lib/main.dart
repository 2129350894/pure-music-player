class LyricLine {
  final Duration time;
  final String text;

  LyricLine({required this.time, required this.text});
}

class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String path;
  final Duration? duration;
  
  // Enriched metadata
  String? coverUrl;
  String? localCoverPath;
  List<LyricLine>? lyrics;
  String? localLyricsPath;
  String? genre;
  int? year;
  int? trackNumber;
  
  // UI state
  bool isLoadingMetadata;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.path,
    this.duration,
    this.coverUrl,
    this.localCoverPath,
    this.lyrics,
    this.localLyricsPath,
    this.genre,
    this.year,
    this.trackNumber,
    this.isLoadingMetadata = false,
  });

  factory Song.fromAudioModel(dynamic model) {
    return Song(
      id: model.id.toString(),
      title: cleanTitle(model.title ?? '未知歌曲'),
      artist: model.artist ?? '未知艺人',
      album: model.album ?? '未知专辑',
      path: model.data,
      duration: model.duration != null 
          ? Duration(milliseconds: model.duration!) 
          : null,
    );
  }

  Song copyWith({
    String? title,
    String? artist,
    String? album,
    String? coverUrl,
    String? localCoverPath,
    List<LyricLine>? lyrics,
    String? localLyricsPath,
    String? genre,
    int? year,
    int? trackNumber,
    bool? isLoadingMetadata,
  }) {
    return Song(
      id: id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      path: path,
      duration: duration,
      coverUrl: coverUrl ?? this.coverUrl,
      localCoverPath: localCoverPath ?? this.localCoverPath,
      lyrics: lyrics ?? this.lyrics,
      localLyricsPath: localLyricsPath ?? this.localLyricsPath,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      trackNumber: trackNumber ?? this.trackNumber,
      isLoadingMetadata: isLoadingMetadata ?? this.isLoadingMetadata,
    );
  }

  static String cleanTitle(String title) {
    // Remove common suffixes added by downloaders
    final patterns = [
      RegExp(r'\s*\(.*?\)', caseSensitive: false),
      RegExp(r'\s*\[.*?\]', caseSensitive: false),
      RegExp(r'\s*【.*?】', caseSensitive: false),
      RegExp(r'\s*official.*?video', caseSensitive: false),
      RegExp(r'\s*MV', caseSensitive: false),
      RegExp(r'\s*歌词版', caseSensitive: false),
      RegExp(r'\s*Live', caseSensitive: false),
    ];
    
    String cleaned = title;
    for (final pattern in patterns) {
      cleaned = cleaned.replaceAll(pattern, '');
    }
    return cleaned.trim();
  }

  String get displayTitle => title;
  String get displayArtist => artist;
  String get displayAlbum => album;
  
  bool get hasCover => localCoverPath != null || coverUrl != null;
  bool get hasLyrics => lyrics != null && lyrics!.isNotEmpty;
}
