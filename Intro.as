package {	import flash.display.MovieClip;	import flash.events.*;	import flash.media.Sound;
	public class Intro extends MovieClip {		private var nomEcran:String="intro"; 
		private var oui:Sound; 		public function Intro() {
			trace(">>> écran",nomEcran,"créé");		}		private function goPrincipal(e:MouseEvent):void {			MovieClip(parent).goto("principal",this);
			Main(parent).recommencer();
			oui.play();		}
		//active les attribut de la page
		public function activer():void{
			trace("Écran",nomEcran,"activé");
			visible=true;
			oui= new sonOui; // ajoute les son
			btPrincipal.addEventListener(MouseEvent.CLICK, goPrincipal);
			btCredit.addEventListener(MouseEvent.CLICK, goCredit);
			credit_mc.btFermer.addEventListener(MouseEvent.CLICK, goFermer);
			credit_mc.visible=false;
		}
		private function goCredit(e:MouseEvent):void {
			credit_mc.visible=true;
		}
		private function goFermer(e:MouseEvent):void {
			credit_mc.visible=false;
		}
		
		public function desactiver():void{
			trace("Écran",nomEcran,"desactivé");

			// IMPORTANT: désactiver les écouteurs quand la page
			// est désactivée...
			btPrincipal.removeEventListener(MouseEvent.CLICK, goPrincipal);
			
			visible=false;
		}	}//classe}//package