/**
 * Created by jun on 10/8/14.
 */
package edu.du.mobile.model
{

import edu.du.mobile.model.vo.User;
import edu.du.mobile.model.vo.Venue;

import flash.events.Event;

import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import mx.collections.ArrayCollection;

import mx.collections.ArrayCollection;

public class AppModel extends EventDispatcher
{
    private static var _instance:AppModel;

    private var _userCollection:ArrayCollection;

    private var _favoritesCollection:ArrayCollection;

    private var _venuesCollection:ArrayCollection;

    private var _selectedVenue:Venue;

    private var _loggedInUser:User;

    private var _userDB:File = File.applicationStorageDirectory.resolvePath( "users.data" );
    private var _favoritesDB:File = File.applicationStorageDirectory.resolvePath( "favorites.data" );

    ///////////////////////
    public function AppModel( enforcer:SingletonEnforcer )
    {
        _init();
    }

    private function _init():void
    {
        var fileStream:FileStream = new FileStream();

        _venuesCollection = new ArrayCollection();

        if( _userDB.exists )
        {
            fileStream.open( _userDB, FileMode.READ );
            _userCollection = fileStream.readObject() as ArrayCollection;
        }
        else
        {
            _userCollection = new ArrayCollection();
        }
    }

    public static function getInstance():AppModel
    {
        if( _instance == null )
        {
            _instance = new AppModel( new SingletonEnforcer() );
        }

        return _instance;
    }

    public function addUserToCollection( user:User ):void
    {
        _userCollection.addItem( user );
        _updateFile( _userDB, userCollection );



    }

    public function addFavoriteToCollection( venue:Venue ):void
    {
        _favoritesCollection.addItem( venue );
        _updateFile( _favoritesDB, userCollection );
    }

    private function _updateFile( fileToUpdate:File, dataToWrite:Object ):void
    {
        var fileStream:FileStream = new FileStream();
        fileStream.open( fileToUpdate, FileMode.WRITE );

        try
        {
            fileStream.writeObject( dataToWrite );
        }
        catch( error:Error )
        {
            trace( "Error writing to " + fileToUpdate.name );
        }

        fileStream.close();
    }

    //////////////////////////

    public function get userCollection():ArrayCollection
    {
        return _userCollection;
    }

    public function get favoritesCollection():ArrayCollection
    {
        return _favoritesCollection;
    }


    [Bindable]
    public function get venuesCollection():ArrayCollection
    {
        return _venuesCollection;
    }
    public function set venuesCollection( value:ArrayCollection ):void
    {
        _venuesCollection = value;
    }

    [Bindable]
    public function get selectedVenue():Venue
    {
        return _selectedVenue;
    }
    public function set selectedVenue( value:Venue ):void
    {
        _selectedVenue = value;
    }

    [Bindable]
    public function get loggedInUser():User
    {
        return _loggedInUser;
    }
    public function set loggedInUser( value:User ):void
    {
        _loggedInUser = value;
    }
}
}
internal class SingletonEnforcer{}
