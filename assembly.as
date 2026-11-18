enum Operator {LOAD, STORE, ADD, ADDI, SUB, SUBI, HOLD}

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

class Speicher
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

bool running = true
int cursor = 0
int akkumulator = 0
array[Task] commands
Speicher s;

commands.emplace(Operator.ADDI, 50)
commands.emplace(Operator.STORE, 0)
commands.emplace(Operator.LOAD, 1)
commands.emplace(Operator.ADDI, 20)
commands.emplace(Operator.STORE, 1)
commands.emplace(Operator.LOAD, 0)
commands.emplace(Operator.ADD, 1)
commands.emplace(Operator.STORE, 2)
commands.emplace(Operator.HOLD)


s.printRegister()

while running
{
    Task t = commands[cursor]
    cursor++;

    switch t.operator
    {
        case Operator.LOAD
        {
            akkumulator = s.getRegister(t.operand)
        }
        case Operator.STORE
        {
            s.setRegister(t.operand, akkumulator)
        }
        case Operator.ADD
        {
            akkumulator += s.getRegister(t.operand)
        }
        case Operator.ADDI
        {
            akkumulator += t.operand
        }
        case Operator.SUB
        {
            akkumulator -= s.getRegister(t.operand)
        }
        case Operator.SUBI
        {
            akkumulator -= t.operand
        }
        case Operator.HOLD
        {
            running = false
        }
    }
}

print("Compiled to: ")
s.printRegister()
