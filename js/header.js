import loadHtml from './loadHtml.js';

export default async function header() {

    let header = document.getElementById('header');
    let fileHtml = "/header.html";
    let load = await loadHtml(fileHtml);
    header.innerHTML = load;

    /* LOGO CLICK */

    let logo = document.getElementById('logo');

    logo.addEventListener('click', () => {
        window.location.href = '/index.html';
    });

    /* MENU MOBILE EVENT */

    let header_content_left = document.getElementById('header_content_left');
    let header_list_mobile = document.getElementById('header_list_mobile');

    let header_list_mobile_view = false;

    header_content_left.addEventListener('click', () => {
        if (header_list_mobile_view === false) {
            header_list_mobile.style.display = 'flex';
            header_list_mobile_view = true;
        } else {
            header_list_mobile.style.display = 'none';
            header_list_mobile_view = false;
        }
    });

    /* TOP PAGE */

    let top_page = document.getElementById("top_page");
    window.addEventListener('scroll', () => {
        if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
            top_page.style.display = "block";
        } else {
            top_page.style.display = "none";
        }
    });

    top_page.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
}
