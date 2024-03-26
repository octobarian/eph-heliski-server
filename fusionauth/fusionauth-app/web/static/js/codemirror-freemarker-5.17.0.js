/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */

// Provide a freemarker overlay on text/html to highlight variables in email templates
"use strict";

CodeMirror.defineMode('freemarker', function(config, parserConfig) {
  var freemarkerOverlay = {
    token: function(stream, state) {
      if (state.inComment === true) {
        if (stream.match(/.*--]/)) {
          // multi-line comment end
          state.inComment = false;
        } else {
          stream.skipToEnd();
        }
        return "comment";
      }

      if (stream.match(/\[#--.*--]/)) {
        return 'comment';
      } else if (stream.match(/\[#--.*/)) {
        // multi-line comment begin
        state.inComment = true;
        return 'comment';
      } else if (stream.match(/\${[^}]*}/)) {
        return 'variable-2';
      } else if (stream.match(/.*\[\/?[#@][^\]]*]/)) {
        return 'def';
      }
      while (stream.next() != null && !stream.match('${', false) && !stream.match(/\[[@#]/, false)) {
      }
      return null;
    },
    startState: function() {
      return {
        inComment: false
      }
    },
    copyState: function(state) {
      return {
        inComment: state.inComment
      }
    }
  };

  return CodeMirror.overlayMode(CodeMirror.getMode(config, parserConfig.backdrop || 'text/html'), freemarkerOverlay);
});