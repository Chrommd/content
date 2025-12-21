
------------------------------------------------------------------------------------------------------------------------
-- Common 테이블 구현부
------------------------------------------------------------------------------------------------------------------------

Common = 
{
    -- 값만 참조하는 형태
    Test1 = 10,

    -- 함수를 호출해서 뭔가 복잡한 수식을 처리하는 형태
    Test2 = function ()
        return 20
    end,

    -- flow3r 2010.06.21 <>
    -- 한 줄 수식 실행하기(evaluation)
    --
    -- * how it works
    --
    --  [code]
    --  function ApplyEffect(script, value)
    --   return loadstring(script)()(value)
    --  end
    --
    --  print(ApplyEffect("return function (value) return value + value * 0.1 end", 100))
    --
    --  [output]
    --  110
    --
    Eval = function (expr, value1)
        local script = "return function (value) return " .. expr .. " end"

        return loadstring(script)()(value1)
    end
}