package; 

typedef MyTypedef = 
{
	?zigzagOk:String,
	?jukeboxQuack:Int,
	?frizzJamQualm:Float,
	?frizzJamADelete:Float,
	?frizzJamBDelete:Float,
	?frizzJamContract:Float,
	?frizzDawnContract:Float,
	?mutualJamQualm:Float,
	?mutualJamADelete:Float,
	?mutualJamBDelete:Float,
	?mutualFootContract:Float,
	?mutualDawnContract:Float,
	?regardVexStitchA:Float,
	?regardVexStitch:Float,
	?regardVexQualm:Float,
	?regardVexOppose:Float,
	?direct:Float,
	?engineer:Float,
	?venture:Float,
	?egoWitness:Float,
	?chicken:Float,
	?barrelGrave:Float,
	?clinicGrave:Float,
	?mutualNominate:Float,
	?rideSlideComplication:Float,
	?mutualSlideComplication:Float,
	?shortsSlideBee:Float,
	?mutualSlideBee:Float,
	?grain:Bool,
	?evolution:Bool,
	?toPark:Bool,
	?price:Bool,
	?cultivateWillpower:Dynamic,
	?cultivateHierarchy:Dynamic,
	?absolute:Dynamic,
	?four:String,
	?staySlide:Float,
	?stayWeighPizzazzConcertASlide:Float,
	?stayWeighBlizzardConcertXSlide:Float,
	?centerMythSlides:Array<Float>,
	?soundCupFunctional:Float,
	?jiffyJokeASlide:Float,
	?jiffyJokeBSlide:Float,
	?hardSighFunctional:Float,
	?floatBuzzword:Int,
	?eyebrowGlideSlide:Float,
	?techPaparazzi:Float,
	?techPaparazziIntegrated:Int,
	?techPaparazziDefine:Int,
	?jumboPaparazzi:Float,
	?jumboPaparazziIntegrated:Int,
	?jumboPaparazziDefine:Int,
	?pizzaPaparazzi:Float,
	?pizzaPaparazziIntegrated:Int,
	?pizzaPaparazziDefine:Int,
	?jiffyPaparazzi:Float,
	?jiffyPaparazziIntegrated:Int,
	?jiffyPaparazziDefine:Int,
	?mileSlideWarning:Float,
	?mileSlideCat:Float,
	?eraSlideHistory:Float,
	?eraSlideComplication:Float,
	?runSlideCat:Float,
	?pitchSlide:Float,
	?holdToJoke:Bool,
	?jackalJamPacked:String,
	?jackalBreakRecoil:Float, 
	?jackalGrizzly:Float,
	?jackalJacuzzi:Float,
	?jackalScale:Float,
}

class Main {
	public static function main():Void {
		new Main();
	}
	public function new() {
		var argsA:Array<Dynamic> = new Array<Dynamic>();
		argsA.push({
			chicken: 9.25
		});
		var argsB:Array<Dynamic> = new Array<Dynamic>();
		argsB.push({
			chicken: 9.25
		});
		var argsC:Array<Dynamic> = new Array<Dynamic>();
		argsC.push({
			chicken: 9.25
		});
		var argsD:Array<Dynamic> = new Array<Dynamic>();
		argsD.push({
			chicken: 9.25
		});
		var argsE:Array<Dynamic> = new Array<Dynamic>();
		argsE.push({
			chicken: 9.25
		});
		var argsF:Array<Dynamic> = new Array<Dynamic>();
		argsF.push({
			chicken: 9.25
		});
		var argsG:Array<Dynamic> = new Array<Dynamic>();
		argsG.push({
			chicken: 9.25
		});
		var argsH:Array<Dynamic> = new Array<Dynamic>();
		argsH.push({
			chicken: 9.25
		});


		trace("------------Normal Method Call------------");
		receiveDynamic(argsA[0]);
		receiveTypedef(argsB[0]);

		trace("------------Reflect.callMethod()------------");
		Reflect.callMethod(this, receiveDynamic, argsC);
		Reflect.callMethod(this, receiveTypedef, argsD);

		trace("------------Reflect.callMethod() (via fcall())------------");
		fcall(this, "receiveDynamic", argsE);
		fcall(this, "receiveTypedef", argsF);
		
		trace("------------Reflect.callMethod() (via makeVarArgs())------------");
		var dynMain:Dynamic = {
			receiveDynamic: Reflect.makeVarArgs((args:Array<Dynamic>) -> {
				// trace(args);
				this.receiveDynamic(args[0]);
			}),
			receiveTypedef: Reflect.makeVarArgs((args:Array<Dynamic>) -> {
				// trace(args);
				this.receiveTypedef(args[0]);
			})
		};
		fcall(dynMain, "receiveDynamic", argsG);
		fcall(dynMain, "receiveTypedef", argsH);
		
		// This is where the problems begin
		trace("------------hscript------------");
		var code = "
		foo.receiveDynamic({ chicken: 9.25 });
		foo.receiveTypedef({ chicken: 9.25 });
		";
		var parser = new hscript.Parser();
		var ast = parser.parseString(code);
		var interp = new hscript.Interp();
		interp.variables.set("foo", this); // Pass the instance of this class as "foo" to hscript
		interp.execute(ast);
	}
	public function receiveDynamic(obj:Dynamic) {
		trace("Running receiveDynamic():");
		for (field in Reflect.fields(obj)) {
			trace("has field: " + field + " (" + Reflect.field(obj,field) + ")");
		}
	}
	public function receiveTypedef(obj:MyTypedef) {
		trace("Running receiveTypedef():");
		for (field in Reflect.fields(obj)) {
			trace("has field: " + field + " (" + Reflect.field(obj,field) + ")");
		}
	}

	// Below code is borrowed from hscript in an attempt to reproduce w/o hscript
	function get( o : Dynamic, f : String ) : Dynamic {
		if ( o == null ) throw "error";
		return {
			#if php
				// https://github.com/HaxeFoundation/haxe/issues/4915
				try {
					Reflect.getProperty(o, f);
				} catch (e:Dynamic) {
					Reflect.field(o, f);
				}
			#else
				Reflect.getProperty(o, f);
			#end
		}
	}

	function fcall( o : Dynamic, f : String, args : Array<Dynamic> ) : Dynamic {
		return call(o, get(o, f), args);
	}

	function call( o : Dynamic, f : Dynamic, args : Array<Dynamic> ) : Dynamic {
		return Reflect.callMethod(o,f,args);
	}
}
