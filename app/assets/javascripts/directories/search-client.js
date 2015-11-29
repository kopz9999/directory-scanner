var Directories;
(function (Directories) {
    var SearchClient = (function () {
        function SearchClient(serializedDirectories, resultTable, businessLocalForm, endPoint) {
            this.directories = [];
            this.resultTable = resultTable;
            this.businessLocalForm = businessLocalForm;
            this.endPoint = endPoint;
            this.parseSerializedDirectories(serializedDirectories);
            this.initForm();
        }
        SearchClient.prototype.initForm = function () {
            var _this = this;
            this.businessLocalForm.submit(function (e) {
                _this.doSearch(e);
            });
        };
        SearchClient.prototype.doSearch = function (e) {
            e.preventDefault();
            this.directories.forEach(function (directoryRecord) {
                directoryRecord.searchLocalBusiness();
            });
        };
        SearchClient.prototype.parseSerializedDirectories = function (serializedDirectories) {
            var _this = this;
            var directory;
            serializedDirectories.forEach(function (jsonObject) {
                directory = new Directories.DirectoryRecord(jsonObject, _this);
                if (directory.active) {
                    _this.directories.push(directory);
                }
            });
        };
        return SearchClient;
    })();
    Directories.SearchClient = SearchClient;
})(Directories || (Directories = {}));
//# sourceMappingURL=search-client.js.map