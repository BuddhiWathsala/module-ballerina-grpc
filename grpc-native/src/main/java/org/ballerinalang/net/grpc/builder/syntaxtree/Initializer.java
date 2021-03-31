/*
 *  Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package org.ballerinalang.net.grpc.builder.syntaxtree;

import io.ballerina.compiler.syntax.tree.CheckExpressionNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.ExpressionStatementNode;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants;

public class Initializer {

    public static CheckExpressionNode getCheckExpressionNode(ExpressionNode expression) {
        return NodeFactory.createCheckExpressionNode(
                SyntaxKind.CHECK_ACTION,
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_CHECK,
                expression
        );
    }

    public static ExpressionStatementNode getCallStatementNode(ExpressionNode expression) {
        return NodeFactory.createExpressionStatementNode(
                SyntaxKind.CALL_STATEMENT,
                expression,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        );
    }
}