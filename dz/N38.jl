using HorizonSideRobots

function TryMove(r::Robot,side::HorizonSide)::Bool # Если робот может пойти по направлению, то он идёт и возвращается true, иначе не идёт и false
    if(!isborder(r,side))
        move!(r,side)
        return true
    end
    return false
end

function CheckTurn(current::HorizonSide, previous::HorizonSide)::Integer # Проверяет правый поворот или левый 1-левый поворот, 2 - правый поворот, 0-нет поворота

    if(current == previous)
        return 0
    end
    if(current == TurnLeft(previous))
        return 1
    end
    if(current == TurnRight(previous))
        return 2
    end
    return 0
end

abstract type AbstractRobot # Абстрактный тип робота
end

struct GenericRobot <: AbstractRobot # Конкретный тип робота
    robot::Robot
end

function StopCondition(
    coordinate::AbstractVector{Integer},
    startDir::HorizonSide,
    currentDir::HorizonSide)::Bool # проверяет условие остановки true если надо остановиться
    
    if (coordinate[1]==0 && coordinate[2]==0 && startDir == currentDir)
        return true
    end  
    return false
end

function Summary(turns::AbstractVector{Integer})::Int8 # Делает заключение снаружи робот или внутри 0-внутри 1-снаружи 2-ошибка
    if (turns[1] > turns[2])
        return 0
    end
    if (turns[1] < turns[2])
        return 1
    end
    if (turns[1] == turns[2])
        return 2
    end
end

function GetRobot(r::GenericRobot)::Robot # Вытаскивает переменную робот из GenericRobot
    return r.robot
end

#Следующие три строки переопределяют функции для типа AbstractRobot
TryMove(r::AbstractRobot,side::HorizonSide) = TryMove(GetRobot(r),side)
ChooseDirection(r::AbstractRobot, direction::HorizonSide) = ChooseDirection(GetRobot(r), direction)
ChooseFirstDirection(r::AbstractRobot) = ChooseFirstDirection(GetRobot(r))



function AroundBorder(r::AbstractRobot)::Int8 # Главная функция которая запускает движение робота и в конце определяет его положение
    #инициализация нужных для работы переменных 
    direction::HorizonSide = Nord
    previousMoveDirection::HorizonSide = Nord
    startDirection::HorizonSide = direction
    turns::AbstractVector{Integer} = [0,0] #1-левый поворот, 2 - правый поворот
    coordinate::AbstractVector{Integer} = [0,0] 

    direction = ChooseFirstDirection(r)
    #основной цикл в котором робот движется, устанавливает свою относительную координату и проверяет сделал ли он поворот
    while (true)
        if (TryMove(r,direction))

            previousMoveDirection = direction
#Устанавливает относительные координаты
            if (direction == Nord || direction == Sud)
                coordinate[1] = coordinate[1] + Counter(direction)
            else
                coordinate[2]=coordinate[2]+Counter(direction)
            end

            direction = ChooseDirection(r,direction)
#Проверяет сделан ли поворот
            if (CheckTurn(direction, previousMoveDirection) == 1)
                turns[1] = turns[1] + 1
            end
            if (CheckTurn(direction, previousMoveDirection) == 2)
                turns[2] = turns[2] + 1
            end

        else 
            ChooseDirection(r,direction)
        end                                                      
#Проверяет условие остановки
        if (StopCondition(coordinate,startDirection,direction))
            return Summary(turns)
            break
        end  
    end

end


function Counter(side::HorizonSide)::Int32 #Возвращает 1 или -1 в зависимости от движения по координатам
    if (side==Nord)
    return 1

    end
    if(side==Ost)
    return+1

    end
    if(side==Sud)
    return -1

    end
    if(side==West)
    return -1
    end
end

function TurnRight(side::HorizonSide)::HorizonSide #Возвращает направление "повёрнутое" направо  

    if(side==Nord)
    return Ost::HorizonSide
    end

    if(side==Ost)
    return Sud::HorizonSide
    end

    if(side==Sud)
    return West::HorizonSide
    end

    if(side==West)
    return Nord::HorizonSide
    end

end

function TurnLeft(side::HorizonSide) #Возвращает направление "повёрнутое" налево
    if(side == Nord)
        return West::HorizonSide
    end

    if(side == West)
        return Sud::HorizonSide
    end

    if(side == Sud)
        return Ost::HorizonSide
    end

    if(side == Ost)
        return Nord::HorizonSide
    end
    
end

function ChooseFirstDirection(r::Robot)::HorizonSide #Выбирает первое направление движения
    direction::HorizonSide = Nord
    while (!isborder(r,TurnRight(direction)))
        direction = TurnRight(direction)
    end
    return direction
end

function ChooseDirection(r::Robot,direction::HorizonSide)::HorizonSide # Выбор направления движения
    if(isborder(r,direction) && isborder(r,TurnRight(direction)) && isborder(r,TurnLeft(direction)))
        return TurnRight(TurnRight(direction))
    end
    
    if(!isborder(r,direction) && isborder(r,TurnRight(direction)))
        return direction
    end

    if(!isborder(r,direction) && !isborder(r,TurnRight(direction)))
        return TurnRight(direction)
    end

    if(isborder(r,direction) && isborder(r,TurnRight(direction)))
        return TurnLeft(direction)
    end

    if(isborder(r,direction) && !isborder(r,TurnRight(direction)))
        return TurnRight(direction)
    end
end