package tw.utils
{
    import flash.display.*;
    import flash.utils.*;

    public class SourceGuard extends Object
    {
        private static var stolen:Boolean;
        private static var stealerMessage:String = "你好\n\n" + 
			<![CDATA[(\___/)]]> + "\n" +  <![CDATA[(='.'=) <------Mad Bunny Skills]]> + "\n" +  <![CDATA[(")(")]]> + "\n不要做壞事喔\n" + "\n乖乖\n";

        public function SourceGuard()
        {
            return;
        }// end function

        private static function killSwf() : void
        {
            // Jump to 32;
            try
            {
                // label
                setTimeout(function testStolen2() { if (stolen) { try { killSwf(); } catch (e:Error) { testStolen(); } finally { testStolen(); } } return; }, 1);
                trace(stealerMessage);
                killSwf();
                // Jump to 10;
                testStolen();
            }// end try
            catch (error:Error)
            {
                testStolen();
            }// end catch
            finally
            {
                testStolen();
            }// end finally
            return;
        }// end function

        public static function test(param1:Array, param2:LoaderInfo, param3:Boolean = false) : Boolean
        {
			stolen = true;
			for each (var key in param1)
			{
				if (param2.url.indexOf(key) != -1) stolen = false;
			}
            if (param3)
            {
                return stolen;
            }// end if
            testStolen();
            return stolen;
        }// end function

        public static function testStolen() { if (stolen) { try { killSwf(); } catch (e:Error) { testStolen(); } finally { testStolen(); } } return; }

    }
}
