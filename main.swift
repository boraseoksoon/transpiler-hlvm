//
//  main.swift
//  HLVM
//
//  Created by Seoksoon Jang on 2021/07/17.
//

import Foundation
import SwiftSyntax

//let x = Set<Int>()
//var arr: [Int] = []

//var y: Set<String> = ["a", "b"]
//let x = Set<Int>()
//print("y man : ", y)
//
//print("y man : ", y)
//print("x type is \\(type(of:x)) and x is \\(x))")


// x = Set<Int>()
// x = set()

// let set = Set<Int>()

//hello(msg: "world", isFirst: false)
//
//let name = "JSS"
//var emoji: String = 👍
//print("hey : \\(name) how are you? : \\(emoji)")

//type(of:arr)
//hello(msg: "world", isFirst: false)

//var arr: [Int] = [0,1,2,3,4,5]
//var arr2: [String] = ["", "abc"]
//var arr3 = [Character("a") ,Character("b"), Character("c")]
//
//print(type(of: arr))
//print(type(of: arr2))
//print(type(of: arr3))


//struct Human {
//    var arr: [Int]
//    var set: <Int>
//    var map: [Int : Int]
//}

// var employees = [Human<Programmer>]()

//class Google :
//    id: String = "good"
//
//class Google :
//    id = "good"

// print(i)

//for i in (0...10) {
//    print(i)
//}

//for i in [0,1,2,3,4] :
//    print("i : ", i)

let source5 = """
python {
    let test = 10
    let python = "python variable"
    var yourname = "JSS"

    print("hello python! : \\(test)")
    print("hello \\(python)! : \\(test)")
    print("hello how are you ", yourname)

    func abc(test: String, element: [Int]) -> Void {
        print("hello python! : \\(test), and element: \\(element)")
    }
    abc(test:"hey", element: [0,1])
}
"""

func abc(test: String, element: [Int]) -> Void {
    print("hello python! : \\(test), and element: \\(element)")
}
abc(test:"hey", element: [0,1])

//struct Human<T: Equatable> where T: Numeric {
//    var age: T = 10
//}

func abc() -> Void {}
struct Human<T: Equatable> where T: Numeric {
    var age: T = 10
}




// pass for now: var set3 = Set<String>(["0", "1"])

//var set1 = Set<String>(["0", "1"])
//var c: Set<Int> = Set(arrayLiteral:0,1,2,3)
//var set1 = Set<String>(["0", "1"])

// var c: Set<Int> = Set(arrayLiteral:0,1,2,3)
// c = {0,1,2,3,4}


// x = {String:Int}()
// x = {}

// x = {"a" : 10}

//print("value : ", x["a"])
//print(type(x))

let res = transpile(source5)
print("*********************")
print("*********************")
print("** code generation **")
print(res)

func transpile(_ source: String, to language: Language? = nil) -> String {
    guard let language = language == nil ? recognizeLanguage(from: source) : language
        else { return source }

    let preprocessedSource = preprocess(source: source, for: language)
    let (_, indentedSource) = indent(source: preprocessedSource)
    let AST = try! SyntaxParser.parse(source: indentedSource)
    let generatedCode = generateCode(from: AST, for: language)
    
    return generatedCode
}

func generateCode(from AST: SourceFileSyntax, for language: Language) -> String {
    finalize(source:CodeGenerator(for: language).visit(AST).description, for: language)
    
}

func preprocess(source: String, for language: Language) -> String {
    source
}

func finalize(source: String, for language: Language) -> String {
    switch language {
        case .python:
            return source.replacingOccurrences(of: "print(\"", with: "print(f\"")
        default:
            return source
    }
}

//func inspect(_ node: Syntax) {
//  print(node.syntaxNodeType)
//  print(node)
//  for child in node.children {
//    inspect(child)
//  }
//}
//
//let parsed = try! SyntaxParser.parse(source: source5)
//inspect(Syntax(parsed))

//let array = [1, 2, 3]
//let newArray = array.map {
//  $0 * $0
//}

// temp
let document = SyntaxFactory.makeSourceFile(
  statements: SyntaxFactory.makeCodeBlockItemList([
    SyntaxFactory.makeCodeBlockItem(
      item: Syntax(
        SyntaxFactory.makeVariableDecl(
          attributes: nil,
          modifiers: nil,
          letOrVarKeyword: SyntaxFactory.makeLetKeyword(trailingTrivia: .spaces(1)),
          bindings: SyntaxFactory.makePatternBindingList([
            SyntaxFactory.makePatternBinding(
              pattern: PatternSyntax(
                SyntaxFactory.makeIdentifierPattern(
                  identifier: SyntaxFactory.makeIdentifier(
                    "array",
                    trailingTrivia: .spaces(1)
                  )
                )
              ),
              typeAnnotation: nil,
              initializer: SyntaxFactory.makeInitializerClause(
                equal: SyntaxFactory.makeEqualToken(trailingTrivia: .spaces(1)),
                value: ExprSyntax(
                  SyntaxFactory.makeArrayExpr(
                    leftSquare: SyntaxFactory.makeLeftSquareBracketToken(),
                    elements: SyntaxFactory.makeArrayElementList([
                      SyntaxFactory.makeArrayElement(
                        expression: ExprSyntax(
                          SyntaxFactory.makeIntegerLiteralExpr(
                            digits: SyntaxFactory.makeIntegerLiteral("1")
                          )
                        ),
                        trailingComma: SyntaxFactory.makeCommaToken(
                          trailingTrivia: .spaces(1)
                        )
                      ),
                      SyntaxFactory.makeArrayElement(
                        expression: ExprSyntax(
                          SyntaxFactory.makeIntegerLiteralExpr(
                            digits: SyntaxFactory.makeIntegerLiteral("2")
                          )
                        ),
                        trailingComma: SyntaxFactory.makeCommaToken(
                          trailingTrivia: .spaces(1)
                        )
                      ),
                      SyntaxFactory.makeArrayElement(
                        expression: ExprSyntax(
                          SyntaxFactory.makeIntegerLiteralExpr(
                            digits: SyntaxFactory.makeIntegerLiteral("3")
                          )
                        ),
                        trailingComma: nil
                      ),
                    ]),
                    rightSquare: SyntaxFactory.makeRightSquareBracketToken()
                  )
                )
              ),
              accessor: nil,
              trailingComma: nil
            )
          ])
        )
      ),
      semicolon: nil,
      errorTokens: nil
    ),
    SyntaxFactory.makeCodeBlockItem(
      item: Syntax(
        SyntaxFactory.makeVariableDecl(
          attributes: nil,
          modifiers: nil,
          letOrVarKeyword: SyntaxFactory.makeLetKeyword(
            leadingTrivia: .newlines(1),
            trailingTrivia: .spaces(1)
          ),
          bindings: SyntaxFactory.makePatternBindingList([
            SyntaxFactory.makePatternBinding(
              pattern: PatternSyntax(
                SyntaxFactory.makeIdentifierPattern(
                  identifier: SyntaxFactory.makeIdentifier(
                    "newArray",
                    trailingTrivia: .spaces(1)
                  )
                )
              ),
              typeAnnotation: nil,
              initializer: SyntaxFactory.makeInitializerClause(
                equal: SyntaxFactory.makeEqualToken(trailingTrivia: .spaces(1)),
                value: ExprSyntax(
                    SyntaxFactory.makeFunctionCallExpr(
                      calledExpression: ExprSyntax(
                        SyntaxFactory.makeMemberAccessExpr(
                          base: ExprSyntax(
                            SyntaxFactory.makeIdentifierExpr(
                              identifier: SyntaxFactory.makeIdentifier("array"),
                              declNameArguments: nil
                            )
                          ),
                          dot: SyntaxFactory.makePeriodToken(),
                          name: SyntaxFactory.makeIdentifier("map", trailingTrivia: .spaces(1)),
                          declNameArguments: nil
                        )
                      ),
                    leftParen: nil,
                    argumentList: SyntaxFactory.makeTupleExprElementList([]),
                    rightParen: nil,
                    trailingClosure: SyntaxFactory.makeClosureExpr(
                      leftBrace: SyntaxFactory.makeLeftBraceToken(),
                      signature: nil,
                      statements: SyntaxFactory.makeCodeBlockItemList([
                        SyntaxFactory.makeCodeBlockItem(
                          item: Syntax(
                            SyntaxFactory.makeSequenceExpr(
                              elements: SyntaxFactory.makeExprList([
                                ExprSyntax(
                                  SyntaxFactory.makeIdentifierExpr(
                                    identifier: SyntaxFactory.makeDollarIdentifier(
                                      "$0",
                                      leadingTrivia: [.newlines(1), .spaces(2)],
                                      trailingTrivia: .spaces(1)
                                    ),
                                    declNameArguments: nil
                                  )
                                ),
                                ExprSyntax(
                                  SyntaxFactory.makeBinaryOperatorExpr(
                                    operatorToken: SyntaxFactory.makeBinaryOperator(
                                      "*",
                                      trailingTrivia: .spaces(1)
                                    )
                                  )
                                ),
                                ExprSyntax(
                                  SyntaxFactory.makeIdentifierExpr(
                                    identifier: SyntaxFactory.makeDollarIdentifier(
                                      "$0",
                                      trailingTrivia: .spaces(1)
                                    ),
                                    declNameArguments: nil
                                  )
                                ),
                              ])
                            )
                          ),
                          semicolon: nil,
                          errorTokens: nil
                        )
                      ]),
                      rightBrace: SyntaxFactory.makeRightBraceToken(
                        leadingTrivia: .newlines(1)
                      )
                    ),
                    additionalTrailingClosures: nil
                  )
                )
              ),
              accessor: nil,
              trailingComma: nil
            )
          ])
        )
      ),
      semicolon: nil,
      errorTokens: nil
    ),
  ]),
    eofToken: SyntaxFactory.makeToken(.eof, presence: .missing)
)
