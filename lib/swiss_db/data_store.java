
  private static final java.lang.String DB_NAME = "swissdb";
  private static final int VERSION = 1;

  public DataStore(android.content.Context context){
    super(context, DB_NAME, null, VERSION);
  }

