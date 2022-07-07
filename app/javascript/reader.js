const options = {
  navigation: {
    ratio: {
      left: 1 / 3,
      right: 1 / 3,
    },
    lastPage: {
      goToNextManga: true,
    },
  },
  progress: {
    color: "bg-red-600",
  },
  format: {
    fullheight: {
      scroll: {
        enabled: false,
      },
      page: {
        container: [],
        page: ["h-full", "w-full"],
        image: ["h-full", "m-auto"],
      },
    },
    fullwidth: {
      scroll: {
        enabled: true,
      },
      page: {
        container: [],
        page: ["w-full", "bg-black"],
        image: ["h-full", "m-auto"],
      },
    },
    default: "fullheight",
  },
};

function initReader() {
  const reader = document.getElementById("reader");
  if (!reader) {
    throw new Error("#reader was not found on the DOM.");
  }

  applyFormatToReader(reader);

  const container = getContainer(reader);
  if (!container) {
    throw new Error("#container missing on #reader");
  }

  const nextPageButton = reader.querySelector('[data-role="next-manga"]');
  nextPageButton.addEventListener("click", (e) => {
    e.preventDefault();

    window.location.href = "/";
  });

  const progressBar = reader.querySelector(".progress-bar");
  progressBar.style.width = "0%";
  setClasses(progressBar, [options.progress.color]);

  const observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      if (mutation.type === "attributes") {
        const pages = parseInt(reader.dataset.pages);
        const currentPage = parseInt(reader.dataset.currentPage);

        const newWidth = `${(currentPage * 100) / pages}%`;
        progressBar.style.width = newWidth;
      }
    });
  });

  observer.observe(reader, { attributes: true });

  container.addEventListener("click", (e) => {
    const { width } = getScreenDimensions();
    const clickedLeft = e.clientX <= width * options.navigation.ratio.left;
    const clickedRight =
      e.clientX > width - width * options.navigation.ratio.right;

    if (clickedLeft && canGoLeft(reader)) {
      previousPage(reader);
    } else if (clickedRight && canGoRight(reader)) {
      nextPage(reader);
    } else if (clickedRight && options.navigation.lastPage.goToNextManga) {
      // go to next page
      window.location.href = "/";
    }

    updatePages(reader);
  });

  window.addEventListener("keydown", (e) => {
    if (e.key === "ArrowLeft" && canGoLeft(reader)) {
      previousPage(reader);
    } else if (e.key === "ArrowRight" && canGoRight(reader)) {
      nextPage(reader);
    }
    updatePages(reader);
  });

  updatePages(reader);
}

initReader();

function getScreenDimensions() {
  const width =
    window.innerWidth ||
    document.documentElement.clientWidth ||
    document.body.clientWidth;
  const height =
    window.innerHeight ||
    document.documentElement.clientHeight ||
    document.body.clientHeight;

  return { width, height };
}

function applyFormatToReader(reader) {
  const formatOptions = getReaderFormatOptions(reader);

  const pageFormatOptions = formatOptions.page;
  const container = getContainer(reader);
  const pages = getPages(reader);

  setClasses(container, pageFormatOptions.container);
  pages.forEach((page) => {
    setClasses(page, pageFormatOptions.page);
    setClasses(page.querySelector(".image"), pageFormatOptions.image);
  });
}

function updatePages(reader) {
  const formatOptions = getReaderFormatOptions(reader);
  const { currentPage } = reader.dataset;

  getPages(reader).forEach((element) => {
    element.classList.add("hidden");
    if (element.getAttribute("data-page") == currentPage) {
      element.classList.remove("hidden");
    }
  });

  if (formatOptions.scroll?.enabled) {
    window.scrollTo({ top: 0, behavior: formatOptions.scroll.behavior });
  }
}

function canGoLeft(reader) {
  return parseInt(reader.dataset.currentPage) > 0;
}

function canGoRight(reader) {
  const pages = parseInt(reader.dataset.pages);
  const currentPage = parseInt(reader.dataset.currentPage);

  return currentPage < pages;
}

function nextPage(reader) {
  const currentPage = parseInt(reader.dataset.currentPage);
  reader.dataset.currentPage = String(currentPage + 1);
}

function previousPage(reader) {
  const currentPage = parseInt(reader.dataset.currentPage);
  reader.dataset.currentPage = String(currentPage - 1);
}

function getReaderFormatOptions(reader) {
  const { format } = reader.dataset;

  return options.format[format] || options.format[options.format.default];
}

function getContainer(reader) {
  return reader.querySelector("#container");
}

function getPages(reader) {
  return reader.querySelectorAll("[data-page]");
}

function setClasses(node, classes) {
  if (classes.length) {
    node.classList.add(...classes);
  }
}
