import Foundation

enum SCNVertexMacroError: CustomStringConvertible, Error {
    
    case requiresArgument(String,SCNVertexMacro.Label)
    case requiresGenericType(String)
    case requiresStruct
    
    var description: String {
        switch self {
        case .requiresArgument(let macro, let label):
            "'#\(macro)' macro requires argument '\(label.rawValue):'."
        case .requiresGenericType(let macro):
            "'#\(macro)' macro requires generic type."
        case .requiresStruct:
            "'@SCNVertex' macro can only be applied to a struct."
        }
    }
}
