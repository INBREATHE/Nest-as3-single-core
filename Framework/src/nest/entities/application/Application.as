/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.entities.application
{
import flash.desktop.NativeApplication;
import flash.events.KeyboardEvent;
import flash.system.Capabilities;
import flash.ui.Keyboard;

import nest.entities.elements.Element;
import nest.entities.elements.Navigator;
import nest.entities.elements.transitions.FadeTransition;
import nest.entities.elements.transitions.Transition;
import nest.entities.screen.Screen;
import nest.interfaces.IElement;
import nest.interfaces.INotifier;

import starling.display.DisplayObject;
import starling.display.Sprite;

/**
 * This is screen navigator and main class of application
 * @author Vladimir Minkin
 * VERSION 0.86
 */
public class Application extends Sprite
{
	static public const isIOS			: Boolean = (Capabilities.manufacturer.indexOf("iOS") != -1);
	static public const isAndroid		: Boolean = (Capabilities.manufacturer.indexOf("Android") != -1);

	static public var 
		SCALEFACTOR		: Number = 1
	,	SCREEN_WIDTH	: uint = Capabilities.screenResolutionX
	,	SCREEN_HEIGHT	: uint = Capabilities.screenResolutionY
	
	,	TRANSITIO		: Transition
	;

	
	static public var
		version		: String
	;

	private var
		_that		: Application
	,	_navigator	: Navigator
	;

	private const _screensContainer : Element = new Element();

	protected var _notifier	: INotifier;

	public function Application() {
		_that = this;

		this.addElement(_screensContainer);
		
		Init_AppParams();
		Init_Navigator();

		if(isAndroid || Capabilities.isDebugger)
		{
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
	}

	//==================================================================================================
	private function Init_AppParams():void {
	//==================================================================================================
		const descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
		const ns:Namespace = descriptor.namespace();
		version = descriptor.ns::versionNumber;
	}

	//==================================================================================================
	private function Init_Navigator():void {
	//==================================================================================================
		_navigator = new Navigator(_screensContainer, new FadeTransition());
	}

	//==================================================================================================
	public function addElement(obj:DisplayObject):void {
	//==================================================================================================
		if (obj is IElement) {
			this.addChildAt(obj, getObjectPositionWithPrioriotet(IElement(obj).prioritet))
		} else {
			this.addChild(obj);
		}
	}

	//==================================================================================================
	public function removeElement(obj:DisplayObject):void {
	//==================================================================================================
		obj.removeFromParent();
	}

	//==================================================================================================
	public function showScreen(obj:Screen, isReturn:Boolean = false):void {
	//==================================================================================================
		_navigator.showScreen(obj, isReturn);
	}

	//==================================================================================================
	public function hideScreen(obj:Screen, isReturn:Boolean = false):void {
	//==================================================================================================
		_navigator.hideScreen(obj, isReturn);
	}

	/**
	 * This is the first method that called when framework start
	 * Sent from PrepareBegin command
	 * */
	//==================================================================================================
	public function prepare():void { }
	//==================================================================================================

	//==================================================================================================
	public function initialized():void {
	//==================================================================================================
		_that.dispatchEventWith( ApplicationEvent.READY );
	}

	//==================================================================================================
	public function set notifier(value:INotifier):void {
	//==================================================================================================
		_notifier = value;
	}

	//==================================================================================================
	public function getObjectPositionWithPrioriotet(prioritet:int):uint {
	//==================================================================================================
		var counter:uint = this.numChildren;
		if(counter > 0) {
			var child:DisplayObject = DisplayObject(this.getChildAt(--counter));
			while (counter && child is IElement) {
				if (IElement(child).prioritet <= prioritet) break;
				child = DisplayObject(this.getChildAt(--counter));
			}
			return ++counter;
		} else return counter;
	}

	//==================================================================================================
	protected function onKeyDown(event:KeyboardEvent):void {
	//==================================================================================================
		if( event.keyCode == Keyboard.BACK )
		{
			event.preventDefault();
			event.stopImmediatePropagation();
			_notifier.send( ApplicationNotification.ANDROID_BACK_BUTTON );
		}
	}
}
}
