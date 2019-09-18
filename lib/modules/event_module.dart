class EventModule extends ChangeNotifier{

  // Firebase
  final databaseReference = Firestore.instance;

  List<EventModel> _events = [];

  List<EventModel> get events => _events;

  List<EventModel> get currenClubEvents => (clubId) fetchClubEvents(clubId);

  set addEvent (EventModel ev){
    // _events.add(ev);
    createEvent(ev);
  }

  void fetchClubEvents(String clubId){
    DocumentReference clubRef = databaseReference.document('clubs/$clubId');
    Future<QuerySnapshot> ref =  databaseReference.collection("events").where('club', isEqualTo: clubRef).getDocuments();
    ref.then((item){
      setEvents = _convertToEventsModel(item.documents);
    });

  }

  void createEvent(EventModel ev) async {
    DocumentReference ref = await databaseReference.collection("events")
        .add(ev.map);
  }

  DateTime _convertToDateTime(dt){
    return dt == null ? null : DateTime.fromMillisecondsSinceEpoch(dt.seconds*1000);
  }

  List<EventModel> _convertToEventsModel(List<DocumentSnapshot> data){
    List<EventModel> _eventsModel=[];
    data.forEach((item){
      _eventsModel.add(
        EventModel(
          id: item.documentID,
          club: item.data['club'],
          title: item.data['title']
          description: item.data['description'],
          image: item.data['image'],
          date: _convertToDateTime(item.data['date']),
        )
      );
    });
  }

  Future<String> uploadImage(File image) async {
    String _url;
    if(image != null){
      String _filePath = image.path;
      String _extension = _filePath.split('/').last.split('.').last;
      String _label = _filePath.split('/').last.split('.')[0];
      String _fileName = Random().nextInt(10000).toString()+_label+'.$_extension';
      final StorageReference _storageRef = FirebaseStorage.instance.ref().child(_fileName);

      final StorageUploadTask uploadTask = _storageRef.putFile(image,);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      _url = (await downloadUrl.ref.getDownloadURL());
    }
    return _url;

  }
}