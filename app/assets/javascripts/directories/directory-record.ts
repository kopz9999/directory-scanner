/// <reference path="./search-client.ts"/>

namespace Directories {
  export class DirectoryRecord {
    key: string;
    html_key: string;
    active: boolean;
    container: JQuery;
    searchClient: Directories.SearchClient;
    queryURL: string;
    // state containers
    notFoundContainer: JQuery;
    successContainer: JQuery;
    loadingContainer: JQuery;
    errorContainer: JQuery;
    // data containers
    nameContainer: JQuery;
    addressContainer: JQuery;
    phoneContainer: JQuery;
    urlContainer: JQuery;
    constructor(jsonObject:any, searchClient: Directories.SearchClient) {
      this.key = jsonObject.name;
      this.active = jsonObject.active;
      this.html_key = jsonObject.html_name;
      this.searchClient = searchClient;
      this.container = this.searchClient.resultTable
        .find('#result-'+this.html_key);
      this.queryURL = this.searchClient.endPoint + '?directory_key=' +
        this.key;
      this.initContainers();
    }
    initContainers(){
      this.notFoundContainer = this.container.find('.search-result .not-found');
      this.loadingContainer = this.container.find('.search-result .loading');
      this.errorContainer = this.container.find('.search-result .error');
      this.successContainer = this.container.find('.search-result .success');
      this.nameContainer = this.container.find('.business-name');
      this.addressContainer = this.container.find('.business-address');
      this.phoneContainer = this.container.find('.business-phone');
      this.urlContainer = this.container.find('.business-url a');
    }
    searchLocalBusiness() {
      this.startSearch();
      $.ajax({
         type: "POST",
         url: this.queryURL,
         data: this.searchClient.businessLocalForm.serialize(),
         context: this,
         error: this.onError,
         complete: this.complete,
         success: this.processResult
      });
    }
    startSearch() {
      this.loadingContainer.show();
      this.notFoundContainer.hide();
      this.errorContainer.hide();
      this.successContainer.hide();
      this.nameContainer.text('-');
      this.addressContainer.text('-');
      this.phoneContainer.text('-');
      this.urlContainer.attr('href', '#');
    }
    complete() {
      this.loadingContainer.hide();
    }
    onError(error:XMLHttpRequest) {
      switch (error.status) {
        case 404:
          this.notFoundContainer.show();
        break;
        case 422:
          this.errorContainer.show();
        break;
        default:
          this.errorContainer.show();
        break;
      }
    }
    processResult(result:any) {
      this.successContainer.show();
      this.nameContainer.text(result.name);
      this.addressContainer.text(result.display_address);
      this.phoneContainer.text(result.phone_number);
      if (result.url) {
        this.urlContainer.attr('href', result.url);
      }
    }
  }
}
