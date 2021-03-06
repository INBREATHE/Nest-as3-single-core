/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.interfaces
{

public interface IFacade
{
	function get currentLanguage():String;
	function set currentLanguage(value:String):void;

	function registerProxy		( proxyClass : Class ) : void;
	function retrieveProxy		( proxyName : Class ) : IProxy;
	function removeProxy		( proxyName : String ) : IProxy;
	function hasProxy			( proxyName : String ) : Boolean;

	function registerCommand	( commandName : String, commandClassRef : Class ) : void;
	function removeCommand		( name : String ) : void;
	function hasCommand			( name : String ) : Boolean;

	function registerProcess	( processClassRef : Class ) : void;
	function removeProcess		( processClassRef : Class ) : void;
	function hasProcess			( processClassRef : Class ) : Boolean;

	function registerMediatorAdvance	( mediator : IMediator ) : void;
	function registerPoolCommand		( commandName : String, commandClassRef : Class ) : void;
	function registerCountCommand		( commandName : String, commandClassRef : Class, count:int ) : void;

	function registerMediator	( mediator : IMediator ) : void;
	function retrieveMediator	( mediatorName : String ) : IMediator;
	function removeMediator		( mediatorName : String ) : IMediator;
	function hasMediator		( mediatorName : String ) : Boolean;

	function sendNotification	( notification : INotification ):void;
	function executeCommand		( notification : INotification ):*;
	function runProcess			( notification : INotification ):void;
}
}
