import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

#if false
extension ExprSyntax {
    
    func replaceKeyPathRoot(_ root: TypeSyntax) -> ExprSyntax? {
        var partialKeyPath: KeyPathExprSyntax? = self.as(KeyPathExprSyntax.self)
        partialKeyPath?.root = root
        return ExprSyntax(partialKeyPath)
    }
}
#endif

extension LabeledExprListSyntax {
    func first(name: String) -> LabeledExprSyntax? {
        first{ $0.label?.text == name }
    }
    func firstAndRest(name: String) -> (Element?, Self) {
        (first(name: name), filter { $0.label?.text != name })
    }
    func commaRefresh() -> LabeledExprListSyntax {
        LabeledExprListSyntax {
            for i in self {
                LabeledExprSyntax(label: i.label?.text, expression: i.expression)
            }
        }
    }
}

extension AttributeListSyntax {

    func first(name: String) -> AttributeListSyntax.Element? {
        first {
            switch $0 {
            case .attribute(let attr):
                if attr.attributeName.tokens(viewMode: .all).map({ $0.tokenKind }) == [.identifier(name)] {
                  return true
                }
            default:
                break
            }
            return false
        }
    }

    func contains(name: String) -> Bool {
        contains {
            switch $0 {
            case .attribute(let attr):
                if attr.attributeName.tokens(viewMode: .all).map({ $0.tokenKind }) == [.identifier(name)] {
                  return true
                }
            default:
                break
            }
            return false
        }
    }
}

extension VariableDeclSyntax {
    
    func first(attribute: String, label: String) -> ExprSyntax? {
        attributes
            .first(name: attribute)?
            .as(AttributeSyntax.self)?
            .arguments?
            .as(LabeledExprListSyntax.self)?
            .first(name: label)?
            .expression
    }
    
    var isStatic: Bool {
        modifiers.contains { $0.name.text == "static" }
    }
    
    var isComputed: Bool {
        bindings.contains {
            $0.accessorBlock?.accessors.isComputed == true
        }
    }
}

extension AccessorBlockSyntax.Accessors {
    var isComputed: Bool {
        switch self {
        case .accessors(let accessorDeclList):
            accessorDeclList.contains {
                $0.accessorSpecifier.tokenKind == .keyword(.get)
            }
        case .getter: true
        }
    }
}

// MARK: -

extension SCNVertexMacro {

    public enum Label: String {
        case semantic
        case keyPath
        case vertexFormat
        case separate
        case interleave
        case elements
        case primitiveType
        case polygonElement
    }
    
    enum Attribute: String {
        case attribute = "SCNAttribute"
        case ignore    = "SCNIgnore"
    }
}

#if false
extension LabeledExprListBuilder {
    public static func buildExpression(_ tuple: (label: SCNVertexMacro.Label, expression: ExprSyntax)) -> Self.Component {
        return [LabeledExprSyntax(label: tuple.label, expression: tuple.expression)]
    }
}
#endif

extension LabeledExprListSyntax {
    init(label: SCNVertexMacro.Label, expression: ExprSyntax) {
        self.init { LabeledExprSyntax(label: label.rawValue, expression: expression) }
    }
}

extension LabeledExprSyntax {
    init(label: SCNVertexMacro.Label, expression: ExprSyntax) {
        self.init(label: label.rawValue, expression: expression)
    }
}

extension FreestandingMacroExpansionSyntax {
    var semantic: ExprSyntax {
        macro.text == "position" ? ".vertex" : ".\(macro)"
    }
    func firstExpr(label: SCNVertexMacro.Label) -> ExprSyntax? {
        argumentList.first(name: label.rawValue)?.expression
    }
    func firstAndRest(label: SCNVertexMacro.Label) -> (LabeledExprSyntax?, LabeledExprListSyntax) {
        argumentList.firstAndRest(name: label.rawValue)
    }
}

extension VariableDeclSyntax {
    func first(attribute: SCNVertexMacro.Attribute, label: SCNVertexMacro.Label) -> ExprSyntax? {
        first(attribute: attribute.rawValue, label: label.rawValue)
    }
}

extension AttributeListSyntax {
    func contains(attribute: SCNVertexMacro.Attribute) -> Bool {
        contains(name: attribute.rawValue)
    }
}

// MARK: -

protocol SCNVertexMacroCommon { }

extension SCNVertexMacroCommon {

    static func typedArray(_ type: GenericArgumentListSyntax.Element?,
                          _ args: ExprSyntax?) -> ExprSyntax {
        
        // TODO: nilで例外にするか再検討
        let input = args ?? "[ /* empty */ ]"
        
        return if let type {
            "(\(input)) as [\(type)]"
        } else {
            input
        }
    }

    static func typedData(_ type: GenericArgumentListSyntax.Element,
                          _ args: LabeledExprListSyntax) -> ExprSyntax {
        "TypedData<\(type)>(\(args))"
    }
    
    static func typedBuffer(_ type: GenericArgumentListSyntax.Element,
                            _ args: LabeledExprListSyntax) -> ExprSyntax {
        "TypedBuffer<\(type)>(\(args))"
    }
    
    static func geometryBuilderSource(_ args: LabeledExprListSyntax) -> ExprSyntax {
        "SceneKit_Vertex.GeometryBuilder.Source(\(args))"
    }
    
    static func geometryBuilderElement(_ args: LabeledExprListSyntax) -> ExprSyntax {
        "SceneKit_Vertex.GeometryBuilder.Elements(\(args))"
    }
    
    static func interleaveAttribute(_ args: LabeledExprListSyntax) -> ExprSyntax {
        "SceneKit_Vertex.InterleaveAttribute(\(args))"
    }
    
    static func geometrySource(vertices args: LabeledExprListSyntax) -> ExprSyntax {
        "SCNGeometrySource(vertices: \(args))"
    }

    static func geometrySource(normals args: LabeledExprListSyntax) -> ExprSyntax {
        "SCNGeometrySource(normals: \(args))"
    }

    static func geometrySource(textureCoordinates args: LabeledExprListSyntax) -> ExprSyntax {
        "SCNGeometrySource(textureCoordinates: \(args))"
    }
}
