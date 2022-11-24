function func1() {
document.getElementById("header").setAttribute("role", "region");
document.getElementById("header").setAttribute("aria-label", "header");

document.getElementById("tnf-logo").setAttribute("aria-label", "Taylor & Francis logo");
document.getElementById("mobile-logo").setAttribute("aria-label", "Taylor & Francis log");
if(document.getElementById("herelink") && document.getElementById("LibrarianLink")){
document.getElementById("herelink").setAttribute("aria-label", "Taylor & Francis WebHomePage");
document.getElementById("LibrarianLink").setAttribute("aria-label", "Taylor & Francis LibrarianPage");
}
document.getElementById("footer").setAttribute("role", "region");
document.getElementById("footer").setAttribute("aria-label", "imprints and footer");
document.getElementById("RoutledgeLink").setAttribute("aria-label", "RoutledgeLink");
document.getElementById("cogentoa").setAttribute("aria-label", "cogentoaLink");
document.getElementById("crcpress").setAttribute("aria-label", "crcpressLink");
document.getElementById("tandfonline").setAttribute("aria-label", "tandfonlineLink");

document.getElementById("mobile-RoutledgeLink").setAttribute("aria-label", "RoutledgeLink");
document.getElementById("mobile-cogentoa").setAttribute("aria-label", "cogentoaLink");
document.getElementById("mobile-crcpress").setAttribute("aria-label", "crcpressLink");
document.getElementById("mobile-tandfonline").setAttribute("aria-label", "tandfonlineLink");
document.getElementById("facebook").setAttribute("aria-label", "FacebookLink");
document.getElementById("twitter").setAttribute("aria-label", "TwitterLink");
document.getElementById("Youtube").setAttribute("aria-label", "YouTubeLink");
document.getElementById("social").setAttribute("aria-label", "PinterestLink");

document.getElementById("tab-facebook").setAttribute("aria-label", "FacebookLink");
document.getElementById("tab-twitter").setAttribute("aria-label", "TwitterLink");
document.getElementById("tab-Youtube").setAttribute("aria-label", "YouTubeLink");
document.getElementById("tab-social").setAttribute("aria-label", "PinterestLink");

document.getElementById("mob-facebook").setAttribute("aria-label", "FacebookLink");
document.getElementById("mob-twitter").setAttribute("aria-label", "TwitterLink");
document.getElementById("mob-Youtube").setAttribute("aria-label", "YouTubeLink");
document.getElementById("mob-social").setAttribute("aria-label", "PinterestLink");

}


window.onload = func1;