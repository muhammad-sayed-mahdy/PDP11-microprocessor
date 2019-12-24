#include <iostream>
#include <string>
#include <fstream>
#include <map>
#include <vector>
#include <algorithm>

using namespace std;

pair<string, string> files_names(int, char**);

struct parser
{
    // attributes
    map<string, string> op,             // operations
                        reg;            // registers
    map<int, int> sym;                  // symbols table, holds variables and labels
    vector<int> address;                // maps assembly file addresses to binary file addresses
    int current_address;                // current address in binary file
    string word;                        // binary instruction
    vector<string> extra_words;         // extra words required for the instruction
    // string err_msg;                     // error handling

    // methods
    parser(int);
    void symbols_table(string, int);       // initializes and stores variables and labels
    void line(string, int, bool = true);    // assembly instruction to binary
    string operand(string, int);            
    void error(string, int);                // throws an exception when an error is found
};

string whitespace(string);   // removes whitespace at the start and end of the string
bool is_between(char, char, char);
bool is_number(string, bool = true);
bool is_valid_name(string);
string capitalize(string);  // change all lowercase letters to uppercase ones in a string
string bin(unsigned int, int = 16);          // returns binary value of a decimal number (as string)
int pwr(int, int);
int s_int(string);

int main(int argc, char* argv[])
{
    pair<string, string> files = files_names(argc, argv);
    ifstream fin(files.first);
    ofstream fout(files.second);

    vector<string> program;

    // program.push_back("");

    while (fin.peek() != EOF)    // read code
    {
        string instruction;

        getline(fin, instruction);
        
        program.push_back(instruction);
    }

    parser parse(program.size());

    for (int line_num = 0; line_num < program.size(); ++ line_num)  // find and store variables
    {
        try
        {
            parse.line(program[line_num], line_num);
        }
        catch(string e)
        {
            cout << e << '\n';
            return 1;
        }
    }

    parse.current_address = 0;

    for (int line_num = 0; line_num < program.size(); ++ line_num)  // assembly to binary
    {
        try
        {
            parse.line(program[line_num], line_num);
        }
        catch(string e)
        {
            cout << e << '\n';
            return 1;
        }
        
        string binary = parse.word;
        binary = whitespace(binary);
        if (binary.size() == 0)
        {
            continue;
        }

        fout << parse.word << endl;
        for (auto x : parse.extra_words)
        {
            fout << x << endl;
        }
    }

    fin.close();
    fout.close();

    return 0;
}

parser::parser(int prog_size)
{
    this->address.resize(prog_size + 1);

    this->current_address = 0;

    ifstream aux("operations.txt");
    
    while(aux.peek() != EOF)
    {
        string name, code;
        aux >> name >> code;

        this->op[name] = code;
    }

    aux.close();
    aux.open("registers.txt");

    while(aux.peek() != EOF)
    {
        string name, code;
        aux >> name >> code;

        this->reg[name] = code;
    }
}

void parser::symbols_table(string instruction, int line_num)
{
    instruction = whitespace(instruction);

    if (instruction.size() == 0)
    {
        return;
    }

    int start = 0;
    string delim = "#";
    int end = instruction.find(delim, start);

    if (end == 0)    // this is a variable definition
    {
        start = end + delim.size();
        end = instruction.size();
        
        string val = instruction.substr(start, end - start);
        
        val = whitespace(val);

        // check for characters and use ascii

        if (!is_number(val))
        {
            this->error("Variable value must be numeric.", line_num);
        }
        else
        {
            int x = s_int(val);
            
            this->sym[line_num] = x;

            this->word = bin(x);
        }
    }       
}

void parser::line(string instruction, int line_num, bool var_err)
{
    this->address[line_num] = this->current_address;

    instruction = whitespace(instruction);

    if (instruction.size() == 0)    // empty line
    {
        return;
    }

    ++(this->current_address);

    this->word.clear();
    this->extra_words.clear();

    int start = 0;
    string delim = " ";
    int end = instruction.find(delim, start);
    string key = instruction.substr(start, end - start);
    start = end + delim.size();

    key = whitespace(capitalize(key));

    if (this->op.count(key) > 0)    // operation
    {
        this->word += this->op[key];

        if (this->word.size() == 4) // 2 operand
        {
            delim = ",";
            end = instruction.find(delim, start);

            if (end == string::npos)
            {
                this->error("Two operand intruction but only one found.", line_num);
            }
            else
            {
                key = instruction.substr(start, end - start);
                start = end + delim.size();

                this->word += this->operand(key, line_num);
                
                key = instruction.substr(start, instruction.size() - start);

                this->word += this->operand(key, line_num);
            }
            
        }
        else if (this->word.size() == 10)  // 1 operand
        {
            key = instruction.substr(start, instruction.size() - start);

            this->word += this->operand(key, line_num);
        }
        else if (this->word.size() == 8)    // branching operation
        {
            string val = instruction.substr(start, instruction.size() - start);

            val = capitalize(val);
            val = whitespace(val);

            if (!is_number(val))
            {
                this->error("Branching instruction must take relative offset.", line_num);
            }

            int x = s_int(val);

            x += line_num + 1;

            x = this->address[x];

            x -= this->current_address;


            this->word += bin(x, 8);    // offset doesn't match (asm - bin)

            // this->word += this->operand(key, line_num);
        }
        else if (this->word == "1110000000000000")    // JSR
        {
            string val = instruction.substr(start, instruction.size() - start);
            val = whitespace(val);
            
            if (!is_number(val))
            {
                this->error("JSR must take a numeric value.", line_num);
            }
            
            this->extra_words.push_back(bin(this->address[s_int(val)]));
        }
        else    // no operand operation
        {
            /* nothings needs to be done */;
        }
        
    }
    else if (key[0] == '#')  // variable definition
    {
        this->symbols_table(instruction, line_num);
    }
    else if (is_number(key))
    {
        this->error("Unknown instruction '" + key + "' .", line_num);
    }
    else
    {
        this->error("Unknown identifier '" + key + "' .", line_num);
    }
    
    
    this->current_address += this->extra_words.size();
}

string parser::operand(string op, int line_num)
{
    op = whitespace(op);
    
    if (op[0] == '#') // variable
    {
        string w = "010111";    // (R7)+

        string val = op.substr(1, op.size() - 1);
        val = whitespace(val);
        
        if (!is_number(val))
        {
            this->error("Operand must take a numeric value after '#'.", line_num);
        }

        this->extra_words.push_back(bin(s_int(val)));

        return w;
    }
    else if (op[0] == '@') // register
    {
        string tmp = this->operand(op.substr(1, op.size() - 1), line_num);  // get as direct
        tmp[2] = '1';   //change to indirect
        // this->word += tmp;
        return tmp;
    }
    else if (op[0] == '-') // auto-decrement
    {
        int start = op.find("-(", 0);
        int end = op.find(")", 0);

        if (start == string::npos || end == string::npos)
        {
            this->error("Incorrect addressing mode '" + op + "' .", line_num);
        }

        start += 2;
        string val = op.substr(start, end - start);
        val = whitespace(val);

        return "100" + this->reg[capitalize(val)];
    }
    else if (op[0] == '(') // auto-increment
    {
        int start = op.find("(", 0);
        int end = op.find(")+", 0);

        if (start == string::npos || end == string::npos)
        {
            this->error("Incorrect addressing mode '" + op + "' .", line_num);
        }

        start += 1;
        string val = op.substr(start, end - start);
        val = whitespace(val);

        return "010" + this->reg[capitalize(val)];
    }
    else if (this->reg.count(op) > 0)   // register
    {
        return "000" + this->reg[op];
    }
    else if (is_between(op[0], '0', '9'))   // numebr or indexed
    {
        int start = 0;
        string delim = "(";
        int end = op.find(delim, start);
        if (end != string::npos)  // indexed
        {
            string val = op.substr(start, end - start);
            val = whitespace(val);
            
            if (!is_number(val))
            {
                this->error("Indexed mode must have a number.", line_num);
            }

            int x = s_int(val);

            this->extra_words.push_back(bin(x));

            start = end + delim.size();
            end = op.find(")", start);

            if (end == string::npos)
            {
                this->error("Expected ')'.", line_num);
            }

            string rop = op.substr(start, end - start);
            val = whitespace(rop);
            
            return "110" + this->reg[capitalize(rop)];
        }
        else    // number (address)
        {
            if (!is_number(op))
            {
                this->error("Unknown operand '" + op + "' .", line_num);
            }

            int x = s_int(op);

            this->extra_words.push_back(bin(this->address[x] - this->current_address - 1));
            
            return "110111";    // X(R7)
        }
    }
    else
    {
        this->error("Unknown operand '" + op + "' .", line_num);
    }
    
}

void parser::error(string e, int line_num)
{
        string err_msg = "Error in line " + to_string(line_num) + ":\n\t" + e;
        throw err_msg;
}



pair<string, string> files_names(int argc, char* argv [])
{    
    pair<string, string> files;

    if (argc > 2)
    {
        files.first = argv[1];
        files.second  = argv[2];
    }
    else
    {
        cin >> files.first >> files.second;
    }

    return files;
}

string whitespace(string s)
{
    int i;
    for (i = 0; i < s.size(); ++i)
    {
        if (s[i] != ' ')
        {
            break;
        }
    }
    int j;
    for (j = s.size() - 1; j >= 0; --j)
    {
        if (s[j] != ' ')
        {
            break;
        }
    }
    
    s = s.substr(i, j + 1 - i);

    return s;
}

bool is_between(char c, char from, char to)
{
    if (from > to)
    {
        swap(from, to);
    }

    return (c >= from && c <= to);
}

bool is_number(string s, bool allow_negative)
{
    if (s[0] == '-' && !allow_negative) // don't allow negative values
    {
        return false;
    }
    else if (s[0] == '-' && allow_negative) // allow negative values
    {
        s = s.substr(1, s.size());
    }

    for (auto c : s)
    {
        if (!is_between(c, '0', '9'))
        {
            return false;
        }
    }
    return true;
}

bool is_valid_name(string s)
{
    if (!is_between(s[0], 'A', 'Z') && !is_between(s[0], 'a', 'z'))
    {
        return false;
    }
    for (auto c : s)
    {
        if (!(is_between(c, '0', '9') || is_between(c, 'a', 'z') || is_between(c, 'A', 'Z') || c == '_'))
        {
            return false;
        }
    }
    return true;
}

string capitalize(string s)
{
    for (auto & c : s)
    {
        if (is_between(c, 'a', 'z'))
        {
            c += 'A' - 'a';
        }
    }
    return s;
}

string bin(unsigned int x, int b)
{
    string s;
    s.resize(b, '0');
    for(int i = 0; i < b; ++i)
    {
        s[b-1 - i] += (x & 1);
        x >>= 1;
    }
    return s;
}

int pwr(int b, int e)
{
    int ans = 1;
    while(e--)
    {
        ans *= b;
    }
    return ans;
}

int s_int(string num)
{
    int x = 0;
    int i = 0;
    reverse(num.begin(), num.end());
    for (auto d : num)
    {
        if (d == '-')
        {
            x *= -1;
        }
        else
        {
            x += (d-'0') * pwr(10, i);
            ++i;
        }
        
    }
    return x;
}
