import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct InterleaveAttributeMacro { }

extension InterleaveAttributeMacro: ExpressionMacro {
    
    public static func expansion<Node, Context>(of node: Node, in context: Context) throws -> SwiftSyntax.ExprSyntax where Node : SwiftSyntax.FreestandingMacroExpansionSyntax, Context : SwiftSyntaxMacros.MacroExpansionContext {
        
        let macro = node.macro.trimmedDescription
        let semantic = macro == "position" ? "vertex" : macro
        
#if true
        let keyPath = node.argumentList.first { $0.label?.description == "keyPath"}
#else
        var keyPath = node.argumentList.first { $0.label?.description == "keyPath"}
        
        if let argument = keyPath,
           argument.expression.as(KeyPathExprSyntax.self)?.root == nil {
            var kp = argument.expression.as(KeyPathExprSyntax.self)
            kp?.root = "Self"
            keyPath?.expression = kp?.as(ExprSyntax.self) ?? argument.expression
        }
#endif

        guard let vertexFormat = node.argumentList.first(where: { $0.label?.description == "vertexFormat" }) else {
            return "SceneKit_Vertex.InterleaveAttribute(\(raw: keyPath?.description ?? "keyPath: \\Self.\(macro)"), semantic: .\(raw: semantic), vertexFormat: nil)"
        }

        return "SceneKit_Vertex.InterleaveAttribute(\(raw: keyPath?.description ?? "keyPath: \\Self.\(macro), ")semantic: .\(raw: semantic), \(raw: vertexFormat.description))"
    }
}
