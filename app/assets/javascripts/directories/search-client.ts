/// <reference path="./directory-record.ts"/>
/// <reference path="../jquery.d.ts"/>

namespace Directories {
  export class SearchClient {
    protected directories: Array<Directories.DirectoryRecord>;
    public resultTable: JQuery;
    public businessLocalForm: JQuery;
    public endPoint: string;
    constructor(serializedDirectories:Array<Object>, resultTable:JQuery,
        businessLocalForm:JQuery, endPoint: string) {
      this.directories = [];
      this.resultTable = resultTable;
      this.businessLocalForm = businessLocalForm;
      this.endPoint = endPoint;
      this.parseSerializedDirectories(serializedDirectories);
      this.initForm();
    }
    private initForm(){
      this.businessLocalForm.submit(e => {
        this.doSearch(e);
      });
    }
    private doSearch(e:BaseJQueryEventObject) {
      e.preventDefault();
      this.directories.forEach(directoryRecord => {
        directoryRecord.searchLocalBusiness();
      });
    }
    private parseSerializedDirectories(serializedDirectories:Array<Object>) {
      var directory:Directories.DirectoryRecord;
      serializedDirectories.forEach(jsonObject => {
        directory = new Directories.DirectoryRecord(jsonObject, this);
        if (directory.active) {
          this.directories.push( directory );
        }
      });
    }
  }
}
