|  S   |                    Command & Description                     |
| :--: | :----------------------------------------------------------: |
|  1   |     **i**Inserts text before the current cursor location     |
|  2   |    **I**Inserts text at the beginning of the current line    |
|  3   |     **a**Inserts text after the current cursor location      |
|  4   |       **A**Inserts text at the end of the current line       |
|  5   | **o**Creates a new line for text entry below the cursor location |
|  6   | **O**Creates a new line for text entry above the cursor location |

|  S   |                     Deleting Characters                      |
| :--: | :----------------------------------------------------------: |
|  1   |     **x**Deletes the character under the cursor location     |
|  2   |    **X**Deletes the character before the cursor location     |
|  3   | **dw**Deletes from the current cursor location to the next word |
|  4   | **d^**Deletes from the current cursor position to the beginning of the line |
|  5   | **d$**Deletes from the current cursor position to the end of the line |
|  6   | **D**Deletes from the cursor position to the end of the current line |
|  7   | **dd**Deletes the line the cursor is on 来源： https://www.tutorialspoint.com/unix/unix-quick-guide.htm |

|  S   |                       Change Commands                        |
| :--: | :----------------------------------------------------------: |
|  1   | **cc**Removes the contents of the line, leaving you in insert mode. |
|  2   | **cw**Changes the word the cursor is on from the cursor to the lowercase**w** end of the word. |
|  3   | **r**Replaces the character under the cursor. vi returns to the command mode after the replacement is entered. |
|  4   | **R**Overwrites multiple characters beginning with the character currently under the cursor. You must use **Esc** to stop the overwriting. |
|  5   | **s**Replaces the current character with the character you type. Afterward, you are left in the insert mode. |
|  6   | **S**Deletes the line the cursor is on and replaces it with the new text. After the  new text is entered, vi remains in the insert mode. |

|  S   |                   Copy and Paste Commands                    |
| :--: | :----------------------------------------------------------: |
|  1   |                **yy**Copies the current line.                |
|  2   | **yw**Copies the current word from the character the lowercase w cursor is on, until the end of the word. |
|  3   |         **p**Puts the copied text after the cursor.          |
|  4   |         **P**Puts the yanked text before the cursor.         |

## Replacing Text

```
:s/search/replace/g
```

