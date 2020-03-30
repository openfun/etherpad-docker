function customStart() {
  let staticPath = 'static/skins/education/images';

  /* header */
  let title = document.createElement('h1');
  title.appendChild(document.createTextNode("Pads pour l'Éducation "));
  let span = document.createElement('span');
  span.appendChild(document.createTextNode('par France Université Numérique'));
  title.appendChild(span);

  let link = document.createElement('a');
  link.setAttribute('href', 'https://www.fun-mooc.fr');
  let logo = document.createElement('img');
  logo.setAttribute('src', staticPath + '/logo-fun-blanc.png');
  logo.setAttribute('alt', 'fun-mooc logo');
  link.appendChild(logo);

  let header = document.createElement('header');
  header.appendChild(title);
  header.appendChild(link);

  /* footer */
  let footer = document.createElement('footer');
  let img = document.createElement('img');
  img.setAttribute('src', staticPath + '/crayon.png');
  img.setAttribute('alt', 'pads for education icon');
  footer.appendChild(img);

  /* layout */
  let wrapper = document.getElementById('wrapper');
  document.body.insertBefore(header, wrapper);
  document.body.appendChild(footer);
}
