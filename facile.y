%{
#include <stdlib.h>
#include <stdio.h>
#include <glib.h>
#include <ctype.h>
#include <assert.h>
#include <stdarg.h>

#define YYDEBUG 1

extern int yylex(void);
extern int yyerror(const char *msg);

char* module_name = NULL;
FILE *stream = NULL;
GHashTable *table = NULL;

int var_count = 0;

void begin_code();
void produce_code(GNode* node);
void produce_code_inverse(GNode* node);
void produce_code_litteral(GNode* node);
void end_code();
void debug(char* msg, ...);
void il_debug(char* msg, ...);
%}

%union {
    gulong number;
    gchar *string;
    GNode * node;
}

%debug
%verbose
%define parse.error verbose

%token TOK_IF           "if"
%token TOK_THEN         "then"
%token TOK_ELSE         "else"
%token TOK_ELSE_IF      "elseif"
%token TOK_END          "end"
%token TOK_ENDIF        "endif"

%token TOK_WHILE        "while"
%token TOK_END_WHILE    "endwhile"
%token TOK_DO           "do"

%token TOK_CONTINUE     "continue"
%token TOK_BREAK        "break"

%token TOK_SEMI_COLON   ";"
%token TOK_AFFECTATION  ":="

%token TOK_PRINT        "print"
%token TOK_READ         "read"

%token<string> TOK_IDENTIFIER   "identifier"
%token<number> TOK_NUMBER       "number"

%token TOK_BRACK_OP     "("
%token TOK_BRACK_CL     ")"

%left TOK_OPE_ADD      "+"
%left TOK_OPE_SUB      "-"
%left TOK_OPE_DIV      "/"
%left TOK_OPE_MUL      "*"

%token TOK_TRUE         "true"
%token TOK_FALSE        "false"

%left TOK_AND          "and"
%left TOK_OR           "or"
%left TOK_NOT          "not"
%left TOK_SUP          ">"
%left TOK_INF          "<"
%left TOK_EQUALS       "=="
%left TOK_SUPEQUAL     ">="
%left TOK_INFEQUAL     "<="
%left TOK_COMMENT      "#"

%type<node>    code
%type<node>    expression
%type<node>    instruction
%type<node>    branche
%type<node>    boucle
%type<node>    condition
%type<node>    identifier
%type<node>    print
%type<node>    read
%type<node>    affectation
%type<node>    number

%%

program: code {
    debug("program passed\n");
    begin_code();
    produce_code($1);
    debug("produce passed\n");
    end_code();
    g_node_destroy($1);
};

code: code instruction {
    debug("\ncode passed\n");
    $$ = g_node_new("code");
    g_node_append($$, $1);
    g_node_append($$, $2);
    } | {
        debug("\ncode passed\n");
        $$ = g_node_new("");
};

instruction: affectation | print | read | branche | boucle;

affectation:
    identifier TOK_AFFECTATION expression TOK_SEMI_COLON {
        debug("affectation passed\n");
        $$ = g_node_new("affectation");
        var_count++;
        g_node_append($$, $1);
        g_node_append($$, $3);
};

print: TOK_PRINT expression TOK_SEMI_COLON {
    debug("print passed\n");
    $$ = g_node_new("print");
    g_node_append($$, $2);
};

read: TOK_READ identifier TOK_SEMI_COLON {
    debug("read passed\n");
    $$ = g_node_new("read");
    g_node_append($$, $2);
};

branche:
    TOK_IF condition TOK_THEN code TOK_END {
        debug("if passed\n");
        $$ = g_node_new("if");
        g_node_append($$, $2);
        g_node_append($$, $4);
    }
    |
    TOK_ELSE_IF condition TOK_THEN code {
        debug("elsif end passed\n");
        $$ = g_node_new("elseif");
        g_node_append($$, $2);
        g_node_append($$, $4);
    }
    |
    TOK_ELSE code {
        debug("else passed\n");
        $$ = g_node_new("else");
        g_node_append($$, $2);
};

boucle: TOK_WHILE code TOK_END {
    debug("while passed\n");
    $$ = g_node_new("while");
    g_node_append($$, $2);
};

condition: 
    expression TOK_SUP expression {
        debug("sup passed\n");
        $$ = g_node_new("SUP");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_INF expression {
        debug("inf passed\n");
        $$ = g_node_new("INF");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_INFEQUAL expression {
        debug("infequal passed\n");
        $$ = g_node_new("INFEQUAL");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_SUPEQUAL expression {
        debug("supequal passed\n");
        $$ = g_node_new("SUPEQUAL");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_EQUALS expression {
        debug("equal passed\n");
        $$ = g_node_new("EQUAL");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_NOT expression {
        debug("not passed\n");
        $$ = g_node_new("NOT");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    condition TOK_AND condition {
        debug("and passed\n");
        $$ = g_node_new("AND");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    condition TOK_OR condition {
        debug("or passed\n");
        $$ = g_node_new("OR");
        g_node_append($$, $1);
        g_node_append($$, $3);
};

expression:
    identifier
    |
    number
    |
    expression TOK_OPE_ADD expression {
        debug("add passed\n");
        $$ = g_node_new("add");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_OPE_SUB expression {
        debug("sub passed\n");
        $$ = g_node_new("sub");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_OPE_MUL expression {
        debug("mul passed\n");
        $$ = g_node_new("mul");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_OPE_DIV expression {
        debug("div passed\n");
        $$ = g_node_new("div");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    TOK_BRACK_OP expression TOK_BRACK_CL
    {
        $$ = $2;
};

identifier:
    TOK_IDENTIFIER {
        debug("identifier passed\n");
        $$ = g_node_new("identifier");
        gulong value = (gulong) g_hash_table_lookup(table, $1);
        if (!value) {
            value = g_hash_table_size(table) + 1;
            g_hash_table_insert(table, strdup($1), (gpointer) value);
        }
        g_node_append_data($$, (gpointer)value);
};

number:
    TOK_NUMBER 
    {
        debug("number passed\n");
        $$ = g_node_new("number");
        g_node_append_data($$, (gpointer)$1);
};


%%


void begin_code() {
    // start
    fprintf(stream, ".assembly %s {}\n", module_name);
    fprintf(stream, ".assembly extern mscorlib {}\n");
    fprintf(stream,
    "// method line 1\n.method static void Main ()\n\{\n\t.entrypoint\n");

    // debut de main
    fprintf(stream, "\t.maxstack 10\n");
    if (var_count > 0) {
        fprintf(stream, "\t.locals init (int32");
        for (int i=1; i < var_count; i++) {
            fprintf(stream, ", int32");
        }
        fprintf(stream, ")\n");
    }
    debug("\nbegin passed with %d var detected\n\n", var_count);
}

// condition construct val 0 rien
int flag = 0;

// if construct val
int current_if_label = 0;
int end_if_label = 0;

void produce_code(GNode* node) {
    if (node->data == "code") {
        produce_code(g_node_nth_child(node, 0));
        produce_code(g_node_nth_child(node, 1));
    
    } else if (node->data == "affectation") {
        // declaration d'une variable
        assert(fprintf(
            stream,
            "\t// affectation var %ld\n",
            (long) g_node_nth_child(g_node_nth_child(node, 0), 0)->data - 1)
        );
        produce_code(g_node_nth_child(node, 1));
        fprintf(
            stream,
            "\tstloc\t%ld\n",
            (long) g_node_nth_child(g_node_nth_child(node, 0), 0)->data - 1
        );
        debug("affectation %ld passed\n", (long) g_node_nth_child(g_node_nth_child(node, 0), 0)->data - 1);
    
    } else if (node->data == "add") {
        // ajout de 2 expression
        il_debug("\t// add\n");
        produce_code(g_node_nth_child(node, 0));
        produce_code(g_node_nth_child(node, 1));
        fprintf(stream, "\tadd\n");

        debug("add passed\n");

    } else if (node->data == "sub") {
        // soustraction de 2 expression
        il_debug("\t// sub\n");
        produce_code(g_node_nth_child(node, 0));
        produce_code(g_node_nth_child(node, 1));
        fprintf(stream, "\tsub\n");

        debug("sub passed\n");
    
    } else if (node->data == "mul") {
        // multiplication de 2 expression
        il_debug("\t// mul\n");
        produce_code(g_node_nth_child(node, 0));
        produce_code(g_node_nth_child(node, 1));
        fprintf(stream, "\tmul\n");

        debug("mul passed\n");

    } else if (node->data == "div") {
        // division de 2 expression
        il_debug("\t// div\n");
        produce_code(g_node_nth_child(node, 0));
        produce_code(g_node_nth_child(node, 1));
        fprintf(stream, "\tdiv\n");

        debug("div passed\n");

    } else if (node->data == "number") {
        // c'est un nombre
        il_debug("\t// number\n");
        fprintf(
            stream,
            "\tldc.i4\t%ld\n",
            (long) g_node_nth_child(node, 0)->data
        );

    } else if (node->data == "identifier") {
        // c'est un identifier
        assert(fprintf(
            stream,
            "\t// load var %ld in stack\n",
            (long) g_node_nth_child(node, 0)->data - 1));
        fprintf(
            stream,
            "\tldloc\t%ld\n",
            (long) g_node_nth_child(node, 0)->data - 1
        );

    } else if (node->data == "print") {
        // print d'une expression
        il_debug("\t// stack to print\n");
        produce_code(g_node_nth_child(node, 0));
        fprintf(stream, "\tcall void class [mscorlib] System.Console::WriteLine(int32)\n");

        debug("print passed\n");

    } else if (node->data == "read") {
        // scan d'une expression
        il_debug("\t// read to stack\n");
        fprintf(stream, "\tcall string class [mscorlib]System.Console::ReadLine()\n");
        fprintf(stream, "\tcall int32 int32::Parse(string)\n");
        fprintf(
            stream,
            "\tstloc\t%ld\n",
            (long) g_node_nth_child(g_node_nth_child(node, 0), 0)->data - 1
        );

        debug("read passed\n");

    } else if (node->data == "if") {
        il_debug("\t// if %x\n", current_if_label);
        debug("if started %d\n", current_if_label);

        // utilise 2 label
        current_if_label += 2;
        // sauter le grand if
        end_if_label = current_if_label + g_node_max_height(node);
        // cas ou stock dans des var temp
        int tmp_il = end_if_label;
        int temp_if = current_if_label;

        // condition
        produce_code(g_node_nth_child(node, 0));

        // code interne
        // label de debut de bloc
        fprintf(stream, "IL_%x:", (current_if_label - 1));
        produce_code(g_node_nth_child(node, 1));
        // fin du if
        // label de fin
        if (current_if_label == temp_if) {
            fprintf(stream, "IL_%x:", temp_if);
        }
        fprintf(stream, "IL_%x:", tmp_il);
        current_if_label = tmp_il + 1;

        debug("if passed\n");
        il_debug("\t// endif %i\n", tmp_il);

    } else if (node->data == "elseif") {
        // fin du parent saute fin e on rajoute le label de elseif
        fprintf(stream, "\tbr IL_%x\n", end_if_label);
        fprintf(stream, "IL_%x:", (current_if_label));

        // label
        current_if_label += 2;
        // cas ou on stocke
        int temp = current_if_label;
        int temp_IL = end_if_label;

        il_debug("\t// elseif %i\n", current_if_label - 1);
        // condition
        produce_code(g_node_nth_child(node, 0));

        // code interne
        fprintf(stream, "IL_%x:", (current_if_label - 1));
        produce_code(g_node_nth_child(node, 1));
        // fin du if

        debug("elseif passed\n");

    } else if (node->data == "else") {
        fprintf(stream, "\tbr IL_%x\n", end_if_label);
        fprintf(stream, "IL_%x:", current_if_label);

        // else
        il_debug("\t// else\n");
        produce_code(g_node_nth_child(node, 0));
        current_if_label++;

        debug("else passed\n");

    } else if (node->data == "AND") {
        // condition
        produce_code_inverse(g_node_nth_child(node, 0));
        il_debug("\t// and\n");
        produce_code(g_node_nth_child(node, 1));

    } else if (node->data == "OR") {
        // condition
        current_if_label++;
        produce_code_litteral(g_node_nth_child(node, 0));
        il_debug("\t// OR\n");
        produce_code(g_node_nth_child(node, 1));
        current_if_label--;
    } else if (node->data == "SUP") {
        produce_code_inverse(node);
    } else if (node->data == "INF") {
        produce_code_inverse(node);
    } else if (node->data == "INFEQUAL") {
        produce_code_inverse(node);
    } else if (node->data == "SUPEQUAL") {
        produce_code_inverse(node);
    } else if (node->data == "EQUAL") {
        produce_code_inverse(node);
    } else if (node->data == "NOT") {
        produce_code_inverse(node);
    }
}

// construit les conditions boolean oppose a celle ecrite
void produce_code_inverse(GNode* node) {
    if (node->data == "SUP") {
        il_debug("\t// sup inv\n");
        
        // expression 1
        produce_code(g_node_nth_child(node, 0));
        // expression 2
        produce_code(g_node_nth_child(node, 1));
        // compare l'inverse
        fprintf(stream, "\tble IL_%x\n", current_if_label);

    } else if (node->data == "INF") {
        il_debug("\t// inf inv\n");

        // expression 1
        produce_code(g_node_nth_child(node, 0));
        // expression 2
        produce_code(g_node_nth_child(node, 1));
        // compare l'inverse
        fprintf(stream, "\tbge IL_%x\n", current_if_label);

    } else if (node->data == "INFEQUAL") {
        il_debug("\t// infequal inv\n");

        // expression 1
        produce_code(g_node_nth_child(node, 0));
        // expression 2
        produce_code(g_node_nth_child(node, 1));
        // compare l'inverse
        fprintf(stream, "\tbgt IL_%x\n", current_if_label);

    } else if (node->data == "SUPEQUAL") {
        il_debug("\t// supequal inv\n");

        // expression 1
        produce_code(g_node_nth_child(node, 0));
        // expression 2
        produce_code(g_node_nth_child(node, 1));
        // compare l'inverse
        fprintf(stream, "\tblt IL_%x\n", current_if_label);

    } else if (node->data == "EQUAL") {
        il_debug("\t// equal inv\n");

        // expression 1
        produce_code(g_node_nth_child(node, 0));
        // expression 2
        produce_code(g_node_nth_child(node, 1));
        // compare l'inverse
        fprintf(stream, "\tbne.un IL_%x\n", current_if_label);

    } else if (node->data == "NOT") {
        il_debug("\t// not inv\n");

        // expression 1
        produce_code(g_node_nth_child(node, 0));
        // expression 2
        produce_code(g_node_nth_child(node, 1));
        // compare l'inverse
        fprintf(stream, "\tbeq IL_%x\n", current_if_label);
    }
}

// construit les conditions boolean comme ecrite
void produce_code_litteral(GNode* node) {
    if (node->data == "SUP") {
        il_debug("\t// sup lit\n");
        
        // expression 1
        produce_code(g_node_nth_child(node, 0));
        // expression 2
        produce_code(g_node_nth_child(node, 1));
        // compare l'inverse
        fprintf(stream, "\tbgt IL_%x\n", current_if_label - 1);

    } else if (node->data == "INF") {
        il_debug("\t// inf lit\n");

        // expression 1
        produce_code(g_node_nth_child(node, 0));
        // expression 2
        produce_code(g_node_nth_child(node, 1));
        // compare l'inverse
        fprintf(stream, "\tblt IL_%x\n", current_if_label - 1);

    } else if (node->data == "INFEQUAL") {
        il_debug("\t// infequal lit\n");

        // expression 1
        produce_code(g_node_nth_child(node, 0));
        // expression 2
        produce_code(g_node_nth_child(node, 1));
        // compare l'inverse
        fprintf(stream, "\tble IL_%x\n", current_if_label - 1);

    } else if (node->data == "SUPEQUAL") {
        il_debug("\t// supequal lit\n");

        // expression 1
        produce_code(g_node_nth_child(node, 0));
        // expression 2
        produce_code(g_node_nth_child(node, 1));
        // compare l'inverse
        fprintf(stream, "\tbge IL_%x\n", current_if_label - 1);

    } else if (node->data == "EQUAL") {
        il_debug("\t// equal lit\n");

        // expression 1
        produce_code(g_node_nth_child(node, 0));
        // expression 2
        produce_code(g_node_nth_child(node, 1));
        // compare l'inverse
        fprintf(stream, "\tbeq IL_%x\n", current_if_label - 1);

    } else if (node->data == "NOT") {
        il_debug("\t// not lit\n");

        // expression 1
        produce_code(g_node_nth_child(node, 0));
        // expression 2
        produce_code(g_node_nth_child(node, 1));
        // compare l'inverse
        fprintf(stream, "\tbne.un IL_%x\n", current_if_label - 1);
    }
}

void end_code() {
    fprintf(stream, "\tret\n");
    fprintf(stream,
    "} // end of method %s::Main\n", module_name);
    debug("end passed\n");
}

void il_debug(char* msg, ...) {
    va_list args;
    va_start(args, msg);
    vfprintf(stream, msg, args);
    va_end(args);
}

void debug(char* msg, ...) {
    va_list args;
    va_start(args, msg);
    vprintf(msg, args);
    va_end(args);
}

int yyerror(const char *msg) {
    fprintf(stderr, "%s\n", msg);
}

int main(int argc, char *argv[]) {
    if (argc == 2) {
        char *file_name_input = argv[1];
        char *extension;
        char *directory_delimiter;
        char *basename;

        // c'est un .facile
        extension = rindex(file_name_input,'.');
        if (!extension || strcmp(extension, ".facile") != 0) {
            fprintf(stderr, "Input filename extension must be'.facile'\n");
            return EXIT_FAILURE;
        }

        // si pas de / cherche \\ dans le path
        directory_delimiter = rindex(file_name_input,'/');
        if (!directory_delimiter) {
            directory_delimiter = rindex(file_name_input,'\\');
        }
        
        // recupere le nom du fichier
        if (directory_delimiter) {
            basename = strdup(directory_delimiter + 1);
        } else {
            basename = strdup(file_name_input);
        }
        
        // met le nom dans module
        module_name = strdup(basename);
        
        // remplace . par fin de chaine
        *rindex(module_name,'.') = '\0';

        // remplace .facile par .il de basename
        strcpy(rindex(basename,'.'), ".il");
    
        // fichier doit commencer _ ou une lettre
        char *onechar = module_name;
        if (!isalpha(*onechar) && *onechar !='_') {
            free(basename);
            fprintf(stderr, "Base input filename must start with a letter or an underscore\n");
            return EXIT_FAILURE;
        }
        onechar++;
        
        // pas de caractere speciaux dans le nom
        while (*onechar) {
            if (!isalnum(*onechar) && *onechar !='_') {
                free(basename);
                fprintf(stderr, "Base input filename cannot contains special characters\n");
                return EXIT_FAILURE;
            }
            onechar++;
        }
        
        if (stdin = fopen(file_name_input, "r")) {
            if (stream = fopen(basename, "w")) {
                table = g_hash_table_new_full(g_str_hash, g_str_equal, free, NULL);
                yyparse();
                g_hash_table_destroy(table);
                fclose(stream);
                fclose(stdin);
            } else {
                // probleme d'ouverture
                free(basename);
                fclose(stdin);
                fprintf(stderr, "Output filename cannot be opened\n");
                return EXIT_FAILURE;
            }
        } else {
            // pas de fichier
            free(basename);
            fprintf(stderr, "Input filename cannot be opened\n");
            return EXIT_FAILURE;
        }
        free(basename);
    } else {
        // pas de fichier en argument
        fprintf(stderr, "No input filename given\n");
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
