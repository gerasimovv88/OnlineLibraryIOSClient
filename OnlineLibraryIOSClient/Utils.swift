import Foundation

class Utils {
    public static func stringToEscapedString (string: String) -> String {
        if let result = string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
            return result;
        }
        return ""
    }
    
    public static func stringToByteArray(string: String) -> [UInt8] {
        var result: [UInt8] = [UInt8]()
        for char in string.utf8 {
            result += [char]
        }
        return result
    }
    
}
