// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:genorion_mac_android/Models/flatmodel.dart';
import 'package:genorion_mac_android/Models/pinname.dart';
import 'package:genorion_mac_android/Models/pinstatus.dart';
import 'package:genorion_mac_android/Models/subaccessmodel.dart';
import 'package:genorion_mac_android/Models/subuser.dart';
import 'package:genorion_mac_android/Models/tempuser.dart';
import 'package:genorion_mac_android/Models/userprofike.dart';
import 'package:genorion_mac_android/ProfilePage/photo.dart';
import 'package:genorion_mac_android/SubAccessModels/subaccessplace.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/allpinsscheduled.dart';
import '../Models/devicemodel.dart';
import '../Models/floormodel.dart';
import '../Models/pinschedule.dart';
import '../Models/placemodel.dart';
import '../Models/roommodel.dart';
import '../SubAccessModels/subaccesflat.dart';
import '../SubAccessModels/subaccessdevice.dart';
import '../SubAccessModels/subaccessfloor.dart';
import '../SubAccessModels/subaccessroom.dart';

class AllDatabase {
  static final AllDatabase instance = AllDatabase._init();
  AllDatabase._init();
  Database? _database;
  Directory? directory;

  final String profileTable = "userProfile";

  static const lastname = "last_name";
  static const email = "email";
  static const firstname = "first_name";

  static const _placeTableName = 'placeTable';
  static const columnPlaceId = 'p_id';
  static const columnPlaceName = 'p_type';
  static const columnPlaceUser = 'user';

  static const _floorTableName = 'floorTable';
  static const columnFloorId = 'f_id';
  static const columnFloorName = 'f_name';
  static const columnFloorUser = 'user';

  static const _flatTableName = 'flatTable';
  static const columnFlatName = 'flt_name';
  static const columnFlatId = 'flt_id';
  static const columnFlatUser = 'user';

  static const _roomTableName = 'roomTable';
  static const columnRoomName = 'r_name';
  static const columnRoomId = 'r_id';
  static const columnRoomUser = 'user';

  static const _deviceTable = 'deviceTable';
  static const columnDeviceId = 'd_id';
  static const columnDeviceUser = 'user';
  static const columnDeviceRoomId = 'r_id';
  static const columnDevicedateInstalled = 'date_installed';
  static const columnDeviceNormalId = 'id';

  static const _devicePinNames = 'devicePinNamesValues';
  // static const columnDevicePinId = 'id';
  static const pin1Name = 'pin1Name';
  static const pin2Name = 'pin2Name';
  static const pin3Name = 'pin3Name';
  static const pin4Name = 'pin4Name';
  static const pin5Name = 'pin5Name';
  static const pin6Name = 'pin6Name';
  static const pin7Name = 'pin7Name';
  static const pin8Name = 'pin8Name';
  static const pin9Name = 'pin9Name';
  static const pin10Name = 'pin10Name';
  static const pin11Name = 'pin11Name';
  static const pin12Name = 'pin12Name';
  static const pin13Name = 'pin13Name';
  static const pin14Name = 'pin14Name';
  static const pin15Name = 'pin15Name';
  static const pin16Name = 'pin16Name';
  static const pin17Name = 'pin17Name';
  static const pin18Name = 'pin18Name';
  static const pin19Name = 'pin19Name';
  static const pin20Name = 'pin20Name';
  static const sensor1 = 'sensor1';
  static const sensor2 = 'sensor2';
  static const sensor3 = 'sensor3';
  static const sensor4 = 'sensor4';
  static const sensor5 = 'sensor5';
  static const sensor6 = 'sensor6';
  static const sensor7 = 'sensor7';
  static const sensor8 = 'sensor8';
  static const sensor9 = 'sensor9';
  static const sensor10 = 'sensor10';





  static const _devicePinStatus = 'devicePinStatus';
  static const pin1Status = 'pin1Status';
  static const pin2Status = 'pin2Status';
  static const pin3Status = 'pin3Status';
  static const pin4Status = 'pin4Status';
  static const pin5Status = 'pin5Status';
  static const pin6Status = 'pin6Status';
  static const pin7Status = 'pin7Status';
  static const pin8Status = 'pin8Status';
  static const pin9Status = 'pin9Status';
  static const pin10Status = 'pin10Status';
  static const pin11Status = 'pin11Status';
  static const pin12Status = 'pin12Status';
  static const pin13Status = 'pin13Status';
  static const pin14Status = 'pin14Status';
  static const pin15Status = 'pin15Status';
  static const pin16Status = 'pin16Status';
  static const pin17Status = 'pin17Status';
  static const pin18Status = 'pin18Status';
  static const pin19Status = 'pin19Status';
  static const pin20Status = 'pin20Status';

  // static const sensorTable = 'sensorTable';
  // static const sensorId = 'id';
  // static const sensor1 = 'sensor1';
  // static const sensor2 = 'sensor2';
  // static const sensor3 = 'sensor3';
  // static const sensor4 = 'sensor4';
  // static const sensor5 = 'sensor5';
  // static const sensor6 = 'sensor6';
  // static const sensor7 = 'sensor7';
  // static const sensor8 = 'sensor8';
  // static const sensor9 = 'sensor9';
  // static const sensor10 = 'sensor10';

  static const _devicePinSchedule = '_devicePinSchedule';
  static const user = 'user';
  static const date1 = 'date1';
  static const id = 'id';
  static const timing1 = 'timing1';
  static const schedulePin1Status = 'pin1Status';
  static const schedulePin2Status = 'pin2Status';
  static const schedulePin3Status = 'pin3Status';
  static const schedulePin4Status = 'pin4Status';
  static const schedulePin5Status = 'pin5Status';
  static const schedulePin6Status = 'pin6Status';
  static const schedulePin7Status = 'pin7Status';
  static const schedulePin8Status = 'pin8Status';
  static const schedulePin9Status = 'pin9Status';
  static const schedulePin10Status = 'pin10Status';
  static const schedulePin11Status = 'pin11Status';
  static const schedulePin12Status = 'pin12Status';
  static const schedulePin13Status = 'pin13Status';
  static const schedulePin14Status = 'pin14Status';
  static const schedulePin15Status = 'pin15Status';
  static const schedulePin16Status = 'pin16Status';
  static const schedulePin17Status = 'pin17Status';
  static const schedulePin18Status = 'pin18Status';
  static const schedulePin19Status = 'pin19Status';
  static const schedulePin20Status = 'pin20Status';

  static const _subUserTable = 'subUserTable';
  static const ownerName = 'owner_name';
  static const name = 'name';
  static const subUser = 'user';
  static const emailSubUser = 'email';
  static const subPId = 'p_id';
  static const subUserId = 'id';

  static const _subAcessUserTable = 'subAcessUserTable';
  static const subAcessownerName = 'owner_name';
  static const subAcessname = 'name';
  static const subAcessUser = 'user';
  static const subAcessemail = 'email';
  static const subAcessPId = 'p_id';
  static const subAcessUserId = 'id';

  static const _subPlaceTableName = 'subPlaceTable';
  static const subPlaceId = 'p_id';
  static const subPlaceName = 'p_type';

  static const _subFloorTableName = 'subfloorTable';
  static const subFloorId = 'f_id';
  static const subFloorName = 'f_name';
  static const subFloorUser = 'user';

  static const _subFlatTableName = 'subflatTable';
  static const subFlatName = 'flt_name';
  static const subFlatId = 'flt_id';
  static const subFlatUser = 'user';

  static const _subRoomTableName = 'subroomTable';
  static const subRoomName = 'r_name';
  static const subRoomId = 'r_id';
  static const subRoomUser = 'user';

  static const _subDeviceTable = 'subdeviceTable';
  static const subDeviceId = 'd_id';
  static const subDeviceUser = 'user';
  static const subDeviceRoomId = 'r_id';
  static const subDevicedateInstalled = 'date_installed';
  static const subDeviceNormalId = 'id';

  static const _subDevicePinNames = 'subdevicePinNamesValues';
  // static const columnDevicePinId = 'id';
  static const subPin1Name = 'pin1Name';
  static const subPin2Name = 'pin2Name';
  static const subPin3Name = 'pin3Name';
  static const subPin4Name = 'pin4Name';
  static const subPin5Name = 'pin5Name';
  static const subPin6Name = 'pin6Name';
  static const subPin7Name = 'pin7Name';
  static const subPin8Name = 'pin8Name';
  static const subPin9Name = 'pin9Name';
  static const subPin10Name = 'pin10Name';
  static const subPin11Name = 'pin11Name';
  static const subPin12Name = 'pin12Name';
  static const subPin13Name = 'pin13Name';
  static const subPin14Name = 'pin14Name';
  static const subPin15Name = 'pin15Name';
  static const subPin16Name = 'pin16Name';
  static const subPin17Name = 'pin17Name';
  static const subPin18Name = 'pin18Name';
  static const subPin19Name = 'pin19Name';
  static const subPin20Name = 'pin20Name';

  static const subDevicePinStatus = 'subdevicePinStatus';
  static const subPin1Status = 'pin1Status';
  static const subPin2Status = 'pin2Status';
  static const subPin3Status = 'pin3Status';
  static const subPin4Status = 'pin4Status';
  static const subPin5Status = 'pin5Status';
  static const subPin6Status = 'pin6Status';
  static const subPin7Status = 'pin7Status';
  static const subPin8Status = 'pin8Status';
  static const subPin9Status = 'pin9Status';
  static const subPin10Status = 'pin10Status';
  static const subPin11Status = 'pin11Status';
  static const subPin12Status = 'pin12Status';
  static const subPin13Status = 'pin13Status';
  static const subPin14Status = 'pin14Status';
  static const subPin15Status = 'pin15Status';
  static const subPin16Status = 'pin16Status';
  static const subPin17Status = 'pin17Status';
  static const subPin18Status = 'pin18Status';
  static const subPin19Status = 'pin19Status';
  static const subPin20Status = 'pin20Status';
  static const subSensor1 = 'sensor1';
  static const subSensor2 = 'sensor2';
  static const subSensor3 = 'sensor3';
  static const subSensor4 = 'sensor4';
  static const subSensor5 = 'sensor5';
  static const subSensor6 = 'sensor6';
  static const subSensor7 = 'sensor7';
  static const subSensor8 = 'sensor8';
  static const subSensor9 = 'sensor9';
  static const subSensor10 = 'sensor10';


  static const _tempUserTable = 'tempUserTable';
  static const tempOwnerName = 'owner_name';
  static const tempName = 'name';
  static const tempUser = 'user';
  static const tempemail = 'email';
  static const tempPId = 'p_id';
  static const tempFId = 'f_id';
  static const tempFltId = 'flt_id';
  static const tempRId = 'r_id';
  static const tempDId = 'd_id';
  static const tempUserId = 'id';
  static const tempMobile = 'mobile';
  static const tempDate = 'date';
  static const temptime = 'timing';

  static const _allDevicePinSchedul = 'alldevicepinschedule';
  static const allDeviceUser = 'user';
  static const allDevicedate1 = 'date1';
  static const allDeviceid = 'id';
  static const allDeviceDid = 'd_id';
  static const allDevicetiming1 = 'timing1';
  static const allDeviceschedulePin1Status = 'pin1Status';
  static const allDeviceschedulePin2Status = 'pin2Status';
  static const allDeviceschedulePin3Status = 'pin3Status';
  static const allDeviceschedulePin4Status = 'pin4Status';
  static const allDeviceschedulePin5Status = 'pin5Status';
  static const allDeviceschedulePin6Status = 'pin6Status';
  static const allDeviceschedulePin7Status = 'pin7Status';
  static const allDeviceschedulePin8Status = 'pin8Status';
  static const allDeviceschedulePin9Status = 'pin9Status';
  static const allDeviceschedulePin10Status = 'pin10Status';
  static const allDeviceschedulePin11Status = 'pin11Status';
  static const allDeviceschedulePin12Status = 'pin12Status';
  static const allDeviceschedulePin13Status = 'pin13Status';
  static const allDeviceschedulePin14Status = 'pin14Status';
  static const allDeviceschedulePin15Status = 'pin15Status';
  static const allDeviceschedulePin16Status = 'pin16Status';
  static const allDeviceschedulePin17Status = 'pin17Status';
  static const allDeviceschedulePin18Status = 'pin18Status';
  static const allDeviceschedulePin19Status = 'pin19Status';
  static const allDeviceschedulePin20Status = 'pin20Status';

  static String path2 = "";

  static const photoTable = 'phototable';
  static const String photoId = 'user';
  static const String photoName = 'file';

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initiateDatabase();
      return _database;
    }
  }

  Future<Database> initiateDatabase() async {
    directory = await getApplicationDocumentsDirectory();
    final path = join(directory!.path, "alldatabase.db");
    path2 = path;
    var database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
         CREATE TABLE $profileTable (  $email TEXT,
         $firstname TEXT,$lastname TEXT )
         ''');
      await db.execute('''
         CREATE TABLE $_placeTableName (  $columnPlaceId INTEGER PRIMARY KEY,
         $columnPlaceName TEXT NOT NULL,$columnPlaceUser INTEGER )
         ''');

      await db.execute('''
      CREATE TABLE $_tempUserTable ( $tempOwnerName TEXT, $tempName TEXT, $tempUser INTEGER, $tempemail TEXT,$tempPId INTEGER,
        $tempFId INTEGER,$tempFltId INTEGER,$tempRId INTEGER,$tempDId TINYTEXT,$tempUserId INTEGER ,$tempMobile INTEGER,
        $tempDate TINYTEXT,$temptime DATETIME
      )
         ''');

      await db.execute('''
        CREATE TABLE $_floorTableName($columnFloorId INTEGER NOT NULL PRIMARY KEY , $columnFloorName TEXT NOT NULL ,$columnPlaceId INTEGER,$columnFloorUser INTEGER,FOREIGN KEY($columnFloorId) REFERENCES $_placeTableName ($columnPlaceId ))
        ''');
      await db.execute('''
        CREATE TABLE $_flatTableName($columnFlatId INTEGER NOT NULL PRIMARY KEY , $columnFlatName TEXT NOT NULL ,$columnFloorId INTEGER,$columnFlatUser INTEGER,FOREIGN KEY($columnFlatId) REFERENCES $_floorTableName ($columnFloorId ))
        ''');
      await db.execute('''
        CREATE TABLE $_roomTableName($columnRoomId INTEGER NOT NULL PRIMARY KEY , $columnRoomName TEXT NOT NULL ,$columnFlatId INTEGER,$columnRoomUser INTEGER,FOREIGN KEY($columnRoomId) REFERENCES $_flatTableName ($columnFlatId ))
        ''');

      await db.execute('''
        CREATE TABLE $_deviceTable( $columnDeviceUser INTEGER NOT NULL , $columnRoomId INTEGER NOT NULL,$columnDevicedateInstalled TINYTEXT,$columnDeviceNormalId INTEGER , $columnDeviceId TINYTEXT PRIMARY KEY ,FOREIGN KEY($columnDeviceId) REFERENCES $_roomTableName($columnRoomId))
        ''');

      await db.execute('''
        CREATE TABLE $_devicePinNames( $columnDeviceId TINYTEXT  , $pin1Name TEXT , $pin2Name TEXT NOT NULL , $pin3Name TEXT  ,$pin4Name TEXT,$pin5Name TEXT,$pin6Name TEXT,$pin7Name TEXT,$pin8Name TEXT,$pin9Name TEXT,$pin10Name TEXT,$pin11Name TEXT,$pin12Name TEXT,$pin13Name TEXT,$pin14Name TEXT,$pin15Name TEXT,$pin16Name TEXT,$pin17Name TEXT,$pin18Name TEXT,$pin19Name TEXT,$pin20Name TEXT,FOREIGN KEY($pin1Name) REFERENCES $_deviceTable($columnDeviceId))
        ''');
      await db.execute('''
        CREATE TABLE $_devicePinStatus( $columnDeviceId TINYTEXT, $pin1Status INTEGER , $pin2Status INTEGER  , $pin3Status INTEGER  ,$pin4Status INTEGER,$pin5Status INTEGER,$pin6Status INTEGER,$pin7Status INTEGER,$pin8Status INTEGER,$pin9Status INTEGER,$pin10Status INTEGER,$pin11Status INTEGER,$pin12Status INTEGER,$pin13Status INTEGER,$pin14Status INTEGER,$pin15Status INTEGER,$pin16Status INTEGER,$pin17Status INTEGER,$pin18Status INTEGER,$pin19Status TEXT,$pin20Status TEXT,$sensor1 FLOAT , $sensor2 FLOAT ,$sensor3 FLOAT,$sensor4 FLOAT,$sensor5 FLOAT ,$sensor6 FLOAT ,$sensor7 FLOAT,$sensor8 FLOAT,$sensor9 FLOAT,$sensor10 FLOAT,FOREIGN KEY($pin1Status) REFERENCES $_deviceTable($columnDeviceId))
        ''');
      await db.execute('''
        CREATE TABLE $_devicePinSchedule( $columnDeviceId TINYTEXT, $id INTEGER, $user INTEGER, $date1 TEXT,$timing1 TEXT,  $schedulePin1Status INTEGER , $schedulePin2Status INTEGER  , $schedulePin3Status INTEGER  ,$schedulePin4Status INTEGER,$schedulePin5Status INTEGER,$schedulePin6Status INTEGER,$schedulePin7Status INTEGER,$schedulePin8Status INTEGER,$schedulePin9Status INTEGER,$schedulePin10Status INTEGER,$pin11Status INTEGER,$schedulePin12Status INTEGER,$schedulePin13Status INTEGER,$schedulePin14Status INTEGER,$schedulePin15Status INTEGER,$schedulePin16Status INTEGER,$schedulePin17Status INTEGER,$schedulePin18Status INTEGER,$schedulePin19Status TEXT,$schedulePin20Status TEXT,FOREIGN KEY($schedulePin1Status) REFERENCES $_deviceTable($columnDeviceId))
        ''');
      // await db.execute('''
      //   CREATE TABLE $sensorTable( $columnDeviceId TINYTEXT,$sensor1 FLOAT ,$sensorId INTEGER , $sensor2 FLOAT ,$sensor3 FLOAT,$sensor4 FLOAT,$sensor5 FLOAT ,$sensor6 FLOAT ,$sensor7 FLOAT,$sensor8 FLOAT,$sensor9 FLOAT,$sensor10 FLOAT,FOREIGN KEY($columnDeviceId) REFERENCES $_deviceTable($columnDeviceId))
      //   ''');

      await db.execute('''
      CREATE TABLE $_subUserTable ($subUserId INTEGER, $ownerName TEXT, $name TEXT,$emailSubUser TEXT, $subPId TEXT,$subUser INTEGER )
         ''');

      await db.execute('''
      CREATE TABLE $_subAcessUserTable ($subAcessUserId INTEGER, $subAcessownerName TEXT  , $subAcessname TEXT,$subAcessemail TEXT, $subAcessPId TEXT PRIMARY KEY,$subAcessUser INTEGER )
         ''');
      await db.execute('''
         CREATE TABLE $_subPlaceTableName (  $subPlaceId INTEGER PRIMARY KEY,
         $subPlaceName TEXT ,FOREIGN KEY($subPlaceId) REFERENCES $_subAcessUserTable ($subAcessPId ) )
         ''');

      await db.execute('''
        CREATE TABLE $_subFloorTableName($subFloorId INTEGER NOT NULL PRIMARY KEY , $subFloorName TEXT  ,$subPlaceId INTEGER,$subFloorUser INTEGER,FOREIGN KEY($subFloorId) REFERENCES $_subPlaceTableName ($subPlaceId ))
        ''');
      await db.execute('''
        CREATE TABLE $_subFlatTableName($subFlatId INTEGER NOT NULL PRIMARY KEY , $subFlatName TEXT  ,$subFloorId INTEGER,$subFlatUser INTEGER,FOREIGN KEY($subFloorId) REFERENCES $_subFloorTableName ($subFloorId ))
        ''');

      await db.execute('''
        CREATE TABLE $_subRoomTableName($subRoomId INTEGER NOT NULL PRIMARY KEY , $subRoomName TEXT NOT NULL ,$subFlatId INTEGER,$subRoomUser INTEGER,FOREIGN KEY($subRoomId) REFERENCES $_subFlatTableName ($subFlatId ))
        ''');

      await db.execute('''
        CREATE TABLE $_subDeviceTable( $subDeviceUser INTEGER  , $subRoomId INTEGER NOT NULL,$subDevicedateInstalled TINYTEXT,$subDeviceNormalId INTEGER , $subDeviceId TINYTEXT PRIMARY KEY ,FOREIGN KEY($subDeviceId) REFERENCES $_subRoomTableName($subRoomId))
        ''');

      await db.execute('''
        CREATE TABLE $_subDevicePinNames( $subDeviceId TINYTEXT  , $subPin1Name TEXT , $subPin2Name TEXT  NULL , $subPin3Name TEXT  ,$subPin4Name TEXT,$subPin5Name TEXT,$subPin6Name TEXT,$subPin7Name TEXT,$subPin8Name TEXT,$subPin9Name TEXT,$subPin10Name TEXT,$subPin11Name TEXT,$subPin12Name TEXT,$subPin13Name TEXT,$subPin14Name TEXT,$subPin15Name TEXT,$subPin16Name TEXT,$subPin17Name TEXT,$subPin18Name TEXT,$subPin19Name TEXT,$subPin20Name TEXT,FOREIGN KEY($subPin1Name) REFERENCES $_subDeviceTable($subDeviceId))
        ''');

      await db.execute('''
        CREATE TABLE $subDevicePinStatus( $subDeviceId TINYTEXT, $subPin1Status INTEGER , $subPin2Status INTEGER  , $subPin3Status INTEGER  ,$subPin4Status INTEGER,$subPin5Status INTEGER,$subPin6Status INTEGER,$subPin7Status INTEGER,$subPin8Status INTEGER,$subPin9Status INTEGER,$subPin10Status INTEGER,$subPin11Status INTEGER,$subPin12Status INTEGER,$subPin13Status INTEGER,$subPin14Status INTEGER,$subPin15Status INTEGER,$subPin16Status INTEGER,$subPin17Status INTEGER,$subPin18Status INTEGER,$subPin19Status TEXT,$subPin20Status TEXT,$subSensor1 FLOAT  , $subSensor2 FLOAT ,$subSensor3 FLOAT,$subSensor4 FLOAT,$subSensor5 FLOAT ,$subSensor6 FLOAT ,$subSensor7 FLOAT,$subSensor8 FLOAT,$subSensor9 FLOAT,$subSensor10 FLOAT,FOREIGN KEY($subPin1Status) REFERENCES $_subDeviceTable($subDeviceId))
        ''');

      // await db.execute('''
      //   CREATE TABLE $subSensorTable( $subDeviceId TINYTEXT,$subSensor1 FLOAT ,$subSensorId INTEGER , $subSensor2 FLOAT ,$subSensor3 FLOAT,$subSensor4 FLOAT,$subSensor5 FLOAT ,$subSensor6 FLOAT ,$subSensor7 FLOAT,$subSensor8 FLOAT,$subSensor9 FLOAT,$subSensor10 FLOAT,FOREIGN KEY($subDeviceId) REFERENCES $_subDeviceTable($subDeviceId))
      //   ''');

      await db.execute('''
         CREATE TABLE $_allDevicePinSchedul (  $allDeviceUser INTEGER ,
         $allDevicedate1 TEXT ,$allDeviceid INTEGER,$allDeviceDid TINYTEXT,$allDevicetiming1 TEXT,$allDeviceschedulePin1Status INTEGER, $allDeviceschedulePin2Status INTEGER,$allDeviceschedulePin3Status INTEGER,
         $allDeviceschedulePin4Status INTEGER, $allDeviceschedulePin5Status INTEGER, $allDeviceschedulePin6Status INTEGER,$allDeviceschedulePin7Status INTEGER,$allDeviceschedulePin8Status INTEGER,$allDeviceschedulePin9Status INTEGER,
         $allDeviceschedulePin10Status INTEGER, $allDeviceschedulePin11Status INTEGER , $allDeviceschedulePin12Status INTEGER, $allDeviceschedulePin13Status INTEGER, $allDeviceschedulePin14Status INTEGER, $allDeviceschedulePin15Status INTEGER,
         $allDeviceschedulePin16Status INTEGER, $allDeviceschedulePin17Status INTEGER, $allDeviceschedulePin18Status INTEGER , $allDeviceschedulePin19Status INTEGER,
         $allDeviceschedulePin20Status INTEGER
         )
         ''');

      await db.execute('''
      CREATE TABLE $photoTable ($photoId INTEGER , $photoName TEXT)
''');
    });
    return database;
  }

  Future<void> insertUserDetailsModelData(UserProfile user) async {
    // Get a reference to the database.
    final db = await database;
    await db?.insert(
      profileTable,
      user.toJson(),
    );
  }

  Future<void> insertPlaceModelData(PlaceType placeType) async {
    // Get a reference to the database.
    final db = await database;
    await db?.insert(
      _placeTableName,
      placeType.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updaPlaceModelData(PlaceType placeType) async {
    // Get a reference to the database.
    final db = await database;
    await db?.update(
      _placeTableName,
      placeType.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertFloorModelData(FloorType floorType) async {
    // Get a reference to the database.
    final db = await database;
    await db?.insert(
      _floorTableName,
      floorType.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateFloorModelData(FloorType floorType) async {
    // Get a reference to the database.
    final db = await database;
    await db?.update(
      _floorTableName,
      floorType.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertFlatModelData(FlatType flat) async {
    // Get a reference to the database.
    final db = await database;
    await db?.insert(
      _flatTableName,
      flat.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateFlatModelData(FlatType flat) async {
    // Get a reference to the database.
    final db = await database;
    await db?.update(
      _flatTableName,
      flat.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertRoomModelData(RoomType roomType) async {
    // Get a reference to the database.
    final db = await database;
    await db?.insert(
      _roomTableName,
      roomType.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateRoomModelData(RoomType roomType) async {
    // Get a reference to the database.
    final db = await database;
    await db?.update(
      _roomTableName,
      roomType.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertDeviceModelData(DeviceType device) async {
    // Get a reference to the database.
    final db = await database;
    await db?.insert(
      _deviceTable,
      device.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertDevicePinNames(DevicePinName devicePin) async {
    final db = await database;
    await db?.insert(
      _devicePinNames, devicePin.toJson(),
      // conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> updateDevicePinNames(DevicePinName devicePin) async {
    final db = await database;
    await db?.update(_devicePinNames, devicePin.toJson(),
        where: "d_id =?", whereArgs: [devicePin.dId]
        // conflictAlgorithm: ConflictAlgorithm.replace
        );
  }

  Future<void> insertPinStatusData(DevicePinStatus pinStatus) async {
    final db = await database;
    await db?.insert(
      _devicePinStatus, pinStatus.toJson(),
      // conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> updatePinStatusData(DevicePinStatus pinStatus) async {
    final db = await database;
    await db?.update(_devicePinStatus, pinStatus.toJson(),
        where: "d_id = ?", whereArgs: [pinStatus.dId]
        // conflictAlgorithm: ConflictAlgorithm.replace
        );
  }

  Future<void> insertDevicePinSchedule(ScheduledPin scheduledPin) async {
    final db = await database;
    await db?.insert(_devicePinSchedule, scheduledPin.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateDevicePinSchedule(ScheduledPin scheduledPin) async {
    final db = await database;
    await db?.update(_devicePinSchedule, scheduledPin.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Future<void> insertSensorData(SensorData sensorData) async {
  //   final db = await database;
  //   await db?.insert(
  //     sensorTable, sensorData.toJson(),
  //     // conflictAlgorithm: ConflictAlgorithm.replace
  //   );
  // }
  //
  // Future<void> updateSensorData(SensorData sensorData) async {
  //   final db = await database;
  //   await db?.update(sensorTable, sensorData.toJson(),
  //       where: "d_id =?", whereArgs: [sensorData.dId]
  //       // conflictAlgorithm: ConflictAlgorithm.replace
  //       );
  // }

  Future<void> updateScheduleData(ScheduledPin scheduledPin) async {
    final db = await database;
    await db?.update(_devicePinSchedule, scheduledPin.toJson(),
        where: "d_id =?",
        whereArgs: [scheduledPin.dId],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateScheduleDataAll(ScheduledPin scheduledPin) async {
    final db = await database;
    await db?.update(_devicePinSchedule, scheduledPin.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future insertAllDevicePinScheduled(AllPinScheduled allPinScheduled) async {
    final db = await database;
    await db?.insert(
      _allDevicePinSchedul, allPinScheduled.toJson(),
      // conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future getFloorById(String id) async {
    final db = await database;
    var result =
        await db!.query("floorTable", where: "p_id = ? ", whereArgs: [id]);

    return result;
  }

  Future getFlatByFId(String id) async {
    final db = await database;
    var result =
        await db!.query("flatTable", where: "f_id = ? ", whereArgs: [id]);

    return result;
  }

  Future getRoomById(String id) async {
    final db = await database;
    var result =
        await db!.query("roomTable", where: "flt_id = ? ", whereArgs: [id]);

    return result;
  }

  Future getDeviceById(String id) async {
    final db = await database;
    var result =
        await db!.query(_deviceTable, where: "r_id = ? ", whereArgs: [id]);

    return result;
  }

  Future getPinNamesByDeviceId(String id) async {
    final db = await database;
    var result = await db
        ?.query("devicePinNamesValues", where: "d_id = ? ", whereArgs: [id]);

    return result;
  }

  Future getPinStatusByDeviceId(String id) async {
    final db = await database;
    var result =
        await db!.query("devicePinStatus", where: "d_id = ? ", whereArgs: [id]);

    return result;
  }

  Future getSensorByDeviceId(String id) async {
    final db = await database;
    var result =
        await db!.query("sensorTable", where: "d_id = ? ", whereArgs: [id]);

    return result;
  }

  Future getScheduledByDeviceId(String id) async {
    final db = await database;
    var result = await db!
        .query("_devicePinSchedule", where: "d_id = ? ", whereArgs: [id]);
    return result;
  }

  queryPlace() async {
    Database? db = await instance.database;
    return await db!.query(_placeTableName);
  }

  queryFloor() async {
    Database? db = await instance.database;

    return await db!.query(_floorTableName);
  }

  queryFlat() async {
    Database? db = await instance.database;

    return await db!.query(_flatTableName);
  }

  queryRoom() async {
    Database? db = await instance.database;

    return await db!.query(_roomTableName);
  }

  queryDevice() async {
    Database? db = await instance.database;

    return await db!.query(_deviceTable);
  }

  queryDevicePinStatus() async {
    Database? db = await instance.database;

    return await db!.query(_devicePinStatus);
  }

  queryDevicePinName() async {
    Database? db = await instance.database;

    return await db!.query(_devicePinNames);
  }

  // querySensor() async {
  //   Database? db = await instance.database;
  //
  //   return await db!.query(sensorTable);
  // }

  queryPersonalData() async {
    Database? db = await instance.database;

    return await db!.query(profileTable);
  }

  queryScheduledPin() async {
    Database? db = await instance.database;

    return await db!.query(_devicePinSchedule);
  }

  queryAllScheduledPin() async {
    Database? db = await instance.database;

    return await db!.query(_allDevicePinSchedul);
  }

  Future updateFloorData(FloorType floorype) async {
    var db = await database;
    return db?.update(_floorTableName, floorype.toJson());
  }

  Future updateFloorDataForName(FloorType floorype) async {
    var db = await database;
    return db?.update(_floorTableName, floorype.toJson(),
        where: 'f_id = ?', whereArgs: [floorype.fId]);
  }

  Future updateFlatData(FlatType flatQuery) async {
    var db = await database;
    return db?.update(_flatTableName, flatQuery.toJson());
  }

  Future updateFlatDataForName(FlatType flatQuery) async {
    var db = await database;
    return db?.update(_flatTableName, flatQuery.toJson(),
        where: 'flt_id = ?', whereArgs: [flatQuery.fltId]);
  }

  Future updateRoomData(RoomType roomType) async {
    var db = await database;
    return db?.update(_roomTableName, roomType.toJson());
  }

  Future updateRoomDataForName(RoomType roomType) async {
    var db = await database;
    return db?.update(_roomTableName, roomType.toJson(),
        where: 'r_id = ?', whereArgs: [roomType.rId]);
  }

  Future updatePinNameData(DevicePinName pinName) async {
    var db = await database;
    return db?.update(_devicePinNames, pinName.toJson(),
        where: "d_id =?", whereArgs: [pinName.dId]);
  }

  Future deletePlaceModel() async {
    var db = await database;
    return db?.delete(_placeTableName);
  }

  Future deleteFloorModel(id) async {
    final db = await database;
    await db?.delete(_floorTableName, where: "f_id = ?", whereArgs: [id]);
  }

  Future deleteFloorModelAll() async {
    final db = await database;
    await db?.delete(_floorTableName);
  }

  Future deleteFlatModel(id) async {
    final db = await database;
    await db?.delete(_flatTableName, where: "flt_id = ?", whereArgs: [id]);
  }

  Future deleteFlatModelAll() async {
    final db = await database;
    await db?.delete(_flatTableName);
  }

  Future deleteRoomModel(id) async {
    final db = await database;
    await db?.delete(_roomTableName, where: "r_id = ?", whereArgs: [id]);
  }

  Future deleteRoomModelAll() async {
    final db = await database;
    await db?.delete(_roomTableName);
  }

  Future deleteDeviceModel(id) async {
    final db = await database;
    await db?.delete(_deviceTable, where: "r_id = ?", whereArgs: [id]);
  }

  Future deleteDeviceModelAll() async {
    final db = await database;
    await db?.delete(_deviceTable);
  }

  Future deleteDevicePinStatusModel(id) async {
    final db = await database;
    await db?.delete(_devicePinStatus, where: "d_id = ?", whereArgs: [id]);
  }

  Future deleteDevicePinStatusAllModel() async {
    final db = await database;
    await db?.delete(_devicePinStatus);
  }

  // Future deleteSensor() async {
  //   final db = await database;
  //   await db?.delete(sensorTable);
  // }
  // Future deleteSensorUsingDeviceId(dId) async {
  //   final db = await database;
  //   await db?.delete(sensorTable,where: "d_id = ?",whereArgs: [dId]);
  // }

  Future deleteScheduledAll() async {
    final db = await database;
    await db?.delete(_devicePinSchedule);
  }



  Future deleteScheduledById(id) async {
    final db = await database;
    await db?.delete(_devicePinSchedule, where: "d_id =?", whereArgs: [id]);
  }

  Future deleteDevicePinNameModel(id) async {
    final db = await database;
    await db?.delete(_devicePinNames, where: "d_id = ? ", whereArgs: [id]);
  }

  Future deleteDevicePinNameModelAll() async {
    final db = await database;
    await db?.delete(_devicePinNames);
  }

  //SubUser

  Future getAllSubUser() async {
    final db = await database;
    return await db?.query(_subUserTable);
  }

  Future deleteAllSubUser() async {
    final db = await database;
    await db?.delete(_subUserTable);
  }

  Future deleteByEmailSubUser(id) async {
    final db = await database;
    await db?.delete(_subUserTable, where: "email = ?", whereArgs: [id]);
  }

  Future deleteAllTempUser() async {
    final db = await database;
    await db?.delete(_tempUserTable);
  }

  Future<void> insertSubUserData(SubUserDetails subUserDetails) async {
    // Get a reference to the database.
    final db = await database;
    await db?.insert(
      _subUserTable,
      subUserDetails.toJson(),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertTempUserData(TempUserDetails tempUserDetails) async {
    // Get a reference to the database.
    final db = await database;
    await db?.insert(
      _tempUserTable,
      tempUserDetails.toJson(),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future getAllTemp() async {
    final db = await database;
    return await db?.query(_tempUserTable);
  }

  Future deleteTempUserUsingMobile(mobile) async {
    final db = await database;
    db?.delete(_tempUserTable, where: "mobile = ?", whereArgs: [mobile]);
  }

// subAccess Database

  Future<void> insertSubAccess(SubAccessModel subAccessModel) async {
    final db = await database;
    await db?.insert(_subAcessUserTable, subAccessModel.toJson());
  }

  Future<void> deleteSubAccess() async {
    final db = await database;

    db?.delete(_subAcessUserTable);
  }

  Future getAllSUbAccess() async {
    final db = await database;
    return db?.query(_subAcessUserTable);
  }

  Future getAllPlacesByOwnerName(name) async {
    final db = await database;
    return db
        ?.query(_subAcessUserTable, where: "owner_name = ?", whereArgs: [name]);
  }

  Future insertAllPlacesSubAccess(SubAccessPlace subAccessPlace) async {
    final db = await database;
    db?.insert(_subPlaceTableName, subAccessPlace.toJson());
  }

  Future getAllPlacesSubAccess() async {
    final db = await database;
    return db?.query(_subPlaceTableName);
  }

  Future getAllPlacesByIdSubAccess(id) async {
    final db = await database;
    return db?.query(_subPlaceTableName, where: "p_id =?", whereArgs: [id]);
  }

  Future deleteAllPlacesSubAccess() async {
    final db = await database;
    db?.delete(_subPlaceTableName);
  }

  // SubAccess Floor

  Future insertAllFloorsSubAccess(SubAccessFloor subAccessFloor) async {
    final db = await database;
    db?.insert(_subFloorTableName, subAccessFloor.toJson());
  }

  Future deleteAllFloorSubAccess() async {
    final db = await database;
    db?.delete(_subFloorTableName);
  }

  Future getAllFloorSubAccess() async {
    final db = await database;
    return db?.query(_subFloorTableName);
  }

  Future getAllFloorByIdSubAccess(id) async {
    final db = await database;
    return db?.query(_subFloorTableName, where: "p_id =?", whereArgs: [id]);
  }

  Future getSingleFloorByIdSubAccess(id) async {
    final db = await database;
    return db?.query(_subFloorTableName, where: "f_id =?", whereArgs: [id]);
  }
//SubAccess Flat

  Future insertAllFlatSubAccess(SubAccessFlat subAccessFlat) async {
    final db = await database;
    db?.insert(_subFlatTableName, subAccessFlat.toJson());
  }

  Future getAllFlatSubAccess() async {
    final db = await database;
    return db?.query(_subFlatTableName);
  }

  Future getAllFlatByIdSubAccess(id) async {
    final db = await database;
    return db?.query(_subFlatTableName, where: "f_id =?", whereArgs: [id]);
  }

  Future getSingleFlatByIdSubAccess(id) async {
    final db = await database;
    return db?.query(_subFlatTableName, where: "flt_id =?", whereArgs: [id]);
  }

  Future deleteAllFlatSubAccess() async {
    final db = await database;
    db?.delete(_subFlatTableName);
  }

  //SubAccess Room
  Future insertAllRoomSubAccess(SubAccessRoom subAccessRoom) async {
    final db = await database;
    db?.insert(_subRoomTableName, subAccessRoom.toJson());
  }

  Future getAllRoomSubAccess() async {
    final db = await database;
    return db?.query(_subRoomTableName);
  }

  Future getAllRoomByIdSubAccess(id) async {
    final db = await database;
    return db?.query(_subRoomTableName, where: "flt_id =?", whereArgs: [id]);
  }

  Future deleteAllRoomSubAccess() async {
    final db = await database;
    db?.delete(_subRoomTableName);
  }

  // SubAccessDevice

  Future insertAllDeviceSubAccess(SubAccessDevice subAccessDevice) async {
    final db = await database;
    db?.insert(_subDeviceTable, subAccessDevice.toJson());
  }

  Future getAllDeviceSubAccess() async {
    final db = await database;
    return db?.query(_subDeviceTable);
  }

  Future getAllDeviceByRIdSubAccess(id) async {
    final db = await database;
    return db?.query(_subDeviceTable, where: "r_id = ?", whereArgs: [id]);
  }

  Future deleteAllDeviceSubAccess() async {
    final db = await database;
    db?.delete(_subDeviceTable);
  }

//SubDevice Pin Status

  Future insertAllDevicePinStatusSubAccess(
      DevicePinStatus devicePinStatus) async {
    final db = await database;
    db?.insert(subDevicePinStatus, devicePinStatus.toJson());
  }

  Future getDevicePinStatusByIdSubAccess(id) async {
    final db = await database;
    return db?.query(subDevicePinStatus, where: "d_id = ?", whereArgs: [id]);
  }

  Future subAcessUpdatePinStatusData(DevicePinStatus pinStatus) async {
    var db = await database;
    return db?.update(subDevicePinStatus, pinStatus.toJson(),
        where: "d_id = ?", whereArgs: [pinStatus.dId]);
  }

  Future subAccessGetAllPinStatus() async{
    final db = await database;
    return db?.query(subDevicePinStatus);
  }

  Future deleteAllDevicePinStatusSubAccess() async {
    final db = await database;
    db?.delete(subDevicePinStatus);
  }

//SubDevice Pin Name
  Future insertAllDevicePinNameSubAccess(DevicePinName devicePinName) async {
    final db = await database;
    db?.insert(_subDevicePinNames, devicePinName.toJson());
  }

  Future getDevicePinNameByIdSubAccess(id) async {
    final db = await database;
    return db?.query(_subDevicePinNames, where: "d_id = ?", whereArgs: [id]);
  }

  Future deleteAllDevicePinNameSubAccess() async {
    final db = await database;
    db?.delete(_subDevicePinNames);
  }

  Future getAllPinNameSubAccess()async{
    final db = await database;

   return db?.query(_subDevicePinNames);
  }


  //SubAccess Sensors Data
  // Future insertAllDeviceSensorSubAccess(SensorData sensorData) async {
  //   final db = await database;
  //   db?.insert(subSensorTable, sensorData.toJson());
  // }
  //
  // Future getSubSensorByDeviceId(id) async {
  //   final db = await database;
  //   return db?.query(subSensorTable, where: "d_id = ?", whereArgs: [id]);
  // }
  //
  // Future deleteAllSensorSubAccess() async {
  //   final db = await database;
  //   db?.delete(subSensorTable);
  // }

  Future pinScheduledDeleteById(id) async {
    final db = await database;
    db?.delete(_allDevicePinSchedul, where: "id = ?", whereArgs: [id]);
  }

  Future savePhoto(PhotoModel photo) async {
    final db = await database;

    await db?.insert(photoTable, photo.toMap());
  }

  Future deletePhoto()async{
        final db = await database;
   db?.delete(photoTable);
 
  }

  Future getPhoto() async {
    final db = await database;
    return db?.query(photoTable);
  }

  Future<void> deleteDatabase() => databaseFactory.deleteDatabase(path2);
}
