import Foundation

enum SCNVertexMacroError: CustomStringConvertible, Error {
    
    case vertexFormat
    case missingLabel
    case missingGenericType
    case notStructDeclSyntax
    
    // TODO: エラーメッセージもう少し整える
    var description: String {
        switch self {
        case .vertexFormat:
            // 属性引数vertexFormatは、@SCNVertexと一緒に利用できません
            "Attribute argument vertexFormat cannot be used with @SCNVertex."
        case .missingLabel:
            "missingLabel"
        case .missingGenericType: 
            "missingGenericType"
        case .notStructDeclSyntax:
            "notStructDeclSyntax"
        }
    }
}
