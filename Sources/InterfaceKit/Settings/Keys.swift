import CoreKit

extension Settings.Keys {
    public struct Interface {
        public struct TabBar {}
        public struct Media {
            public struct Image {}
            public struct Player {}
        }
    }
}
extension Settings.Keys.Interface.Media.Image {
    public static let disk = "com.images.disk"
    public static let cornerRadius = "settings/keys/media/image/cornerRadius"
}
extension Settings.Keys.Interface.Media.Player {
    public static let autoplay   = "settings/keys/media/player/autoplay"
    public static let continuous = "settings/keys/media/player/continuous"
    public static let multiplier = "settings/keys/media/player/multiplier"
    public static let subtitles  = "settings/keys/media/player/subtitles"
}
extension Settings.Keys.Interface.TabBar {
    public static let selectedIndex = "settings/keys/interface/tabbar/selectedIndex"
}

extension String {
    public static var disk: String {
        return Settings.Keys.Interface.Media.Image.disk
    }
}
