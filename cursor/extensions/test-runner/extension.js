const vscode = require('vscode');

let lastTestFile = null;

function activate(context) {
    console.log('Test runner extension is now active');

    let disposable = vscode.commands.registerCommand('extension.runTestFile', async () => {
        const statusBar = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left);
        statusBar.text = "Running test file...";
        statusBar.show();

        const editor = vscode.window.activeTextEditor;
        if (!editor) {
            vscode.window.showInformationMessage('No active editor');
            statusBar.dispose();
            return;
        }

        try {
            const currentFile = editor.document.fileName;
            if (currentFile.includes('test') || currentFile.includes('spec')) {
                lastTestFile = currentFile;
                await vscode.tasks.executeTask(createTestTask(currentFile));
            } else if (lastTestFile) {
                await vscode.tasks.executeTask(createTestTask(lastTestFile));
            } else {
                vscode.window.showInformationMessage('No test file to run');
            }
        } catch (error) {
            vscode.window.showErrorMessage(`Failed to run test: ${error.message}`);
        } finally {
            statusBar.dispose();
        }
    });

    context.subscriptions.push(disposable);
}

function createTestTask(file) {
    return new vscode.Task(
        { type: 'shell', label: 'Run Test File' },
        vscode.TaskScope.Workspace,
        'Run Test File',
        'ruby',
        new vscode.ShellExecution(`dev test ${file}`)
    );
}

module.exports = {
    activate
};