
enum Operator {JMP, INC, DEC, TST, BYE}
class Task
{
    fn init(Operator op, int vl = -1)
    {
        operator = op
        operand = vl

    }
    Operator operator
    int operand = -1
}

class Register
{
    fn init()
    {
        register = createRegsiter(6)
    }

    fn setRegister(int i, int value)
    {
        if (i >= register.size()) { print("Error: i out of range"); return }
        if (value < 0) { print("Error: Can't set register to a negative value"); return }
        register[i] = value
    }

    fn getRegister(int i) -> int
    {
        if (i >= register.size()) { print("Error: i out of range"); exit(1) }
        return register[i]
    }

    fn printRegister()
    {
        print(register)
    }

private:
    fn createRegsiter(int size) -> array[int]
    {
        array[int] a
        for i : size
        {
            a.append(0)
        }
        return a
    }

    array[int] register
}

fn clearRegister(int reg)
{
    int start = commands.size()
    commands.emplace(Operator.TST, reg)
    commands.emplace(Operator.JMP, start + 3)
    commands.emplace(Operator.JMP, start + 5)
    commands.emplace(Operator.DEC, reg)
    commands.emplace(Operator.JMP, start)
}

fn copyRegister(int rfrom, int rto, int rtemp)
{
    clearRegister(rto)
    clearRegister(rtemp)

    int copyLoop = commands.size()
    commands.emplace(Operator.TST, rfrom)
    commands.emplace(Operator.JMP, copyLoop + 3)
    commands.emplace(Operator.JMP, copyLoop + 7)
    commands.emplace(Operator.INC, rto)
    commands.emplace(Operator.INC, rtemp)
    commands.emplace(Operator.DEC, rfrom)
    commands.emplace(Operator.JMP, copyLoop)

    int restoreLoop = commands.size()
    commands.emplace(Operator.TST, rtemp)
    commands.emplace(Operator.JMP, restoreLoop + 3)
    commands.emplace(Operator.JMP, restoreLoop + 6)
    commands.emplace(Operator.INC, rfrom)
    commands.emplace(Operator.DEC, rtemp)
    commands.emplace(Operator.JMP, restoreLoop)
}

fn addition(int r1, int r2)
{
    // ADDITION
    int relidx = commands.size()
    commands.emplace(Operator.TST, r2)
    commands.emplace(Operator.JMP, relidx + 3)
    commands.emplace(Operator.JMP, relidx + 6)
    commands.emplace(Operator.INC, r1)
    commands.emplace(Operator.DEC, r2)
    commands.emplace(Operator.JMP, relidx)
}

fn subtraction(int r1, int r2)
{
    int relidx = commands.size()
    commands.emplace(Operator.TST, r2)
    commands.emplace(Operator.JMP, relidx + 3)
    commands.emplace(Operator.JMP, relidx + 6)
    commands.emplace(Operator.DEC, r1)
    commands.emplace(Operator.DEC, r2)
    commands.emplace(Operator.JMP, relidx)
}

fn multiplication(int r1, int r2, int rres, int freeCopy, int innerTemp)
{
    clearRegister(freeCopy)
    clearRegister(rres)
    clearRegister(innerTemp)

    int relidx = commands.size()
    commands.emplace(Operator.TST, r2)
    commands.emplace(Operator.JMP, relidx + 3)
    commands.emplace(Operator.BYE)
    copyRegister(r1, freeCopy, innerTemp)
    addition(rres, freeCopy)
    commands.emplace(Operator.DEC, r2)
    commands.emplace(Operator.JMP, relidx)
    
    clearRegister(r1)
}



bool running = true
int cursor = 0
array[Task] commands
Register r;

// r.setRegister(0, 5)
// r.setRegister(1, 3)
// r.setRegister(2, 10)
// r.setRegister(3, 6)

// addition(0, 1)
// subtraction(2, 3)
// addition(0, 2)
// commands.emplace(Operator.BYE)

r.setRegister(0, 0)
r.setRegister(1, 3)
r.setRegister(2, 2)

multiplication(1, 2, 0, 3, 4)

r.printRegister()

while running
{
    Task t = commands[cursor]

    if t.operator == Operator.JMP
    {
        cursor = t.operand
    }
    if t.operator == Operator.INC
    {
        r.setRegister(t.operand, r.getRegister(t.operand) + 1)
        cursor += 1
        continue
    }
    if t.operator == Operator.DEC
    {
        r.setRegister(t.operand, r.getRegister(t.operand) - 1)
        cursor += 1
        continue
    }
    if t.operator == Operator.TST
    {
        if(r.getRegister(t.operand) == 0)
        {
            cursor += 2
        }
        else
        {
            cursor += 1
        }
        continue
    }
    if t.operator == Operator.BYE
    {
        running = false
    }
}

print("Solution: ")
r.printRegister()
