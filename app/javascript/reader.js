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
        image: ["h-full", "m-auto", "object-contain"],
      },
    },
    fullwidth: {
      scroll: {
        enabled: true,
      },
      page: {
        container: [],
        page: ["w-full", "bg-black", "min-h-screen"],
        image: ["w-full", "h-full", "m-auto"],
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

  reader.querySelectorAll("[data-role]").forEach((roleButton) => {
    const { role } = roleButton.dataset;

    roleButton.addEventListener("click", (e) => {
      if (role === "dismissable") {
        dismissPopups(reader);
        return;
      }

      e.preventDefault();

      if (role === "next-manga") {
        window.location.href = "/";
      } else if (role === "toggle") {
        const targetId = roleButton.dataset.for;
        const target = document.getElementById(targetId);

        if (target) {
          const hideClass = roleButton.dataset.class || "hidden";
          const toAdd = [...target.classList].includes(hideClass)
            ? hideClass
            : "z-10";
          const toRemove = [...target.classList].includes(hideClass)
            ? "z-10"
            : hideClass;

          target.classList.toggle(toRemove);
          setTimeout(() => {
            target.classList.toggle(toAdd);
          }, 250);
          console.log(target);
          target.dataset.open =
            target.dataset.open === "true" ? "false" : "true";
        } else {
          console.error("Element", `#${targetId}`, "doesn't exit");
        }
      } else if (role === "description") {
        roleButton.classList.toggle("line-clamp-2");
      }
    });
  });

  const progressBar = getProgressBar(reader);
  progressBar.style.width = "0%";
  setClasses(progressBar, [options.progress.color]);

  const observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      if (mutation.type === "attributes") {
        updateProgressBar(reader);
        updateDisplay(reader);
        unlazifyImage(reader);
      }
    });
  });

  observer.observe(reader, { attributes: true });

  container.addEventListener("click", (e) => {
    const { width } = getScreenDimensions();
    const clickedLeft = e.clientX <= width * options.navigation.ratio.left;
    const clickedRight =
      e.clientX > width - width * options.navigation.ratio.right;

    navigateToPage(reader, clickedLeft, clickedRight);
    updatePages(reader);
  });

  window.addEventListener("keydown", (e) => {
    if (e.key === "r") {
      window.location.href = "/";
    } else {
      navigateToPage(reader, e.key === "ArrowLeft", e.key === "ArrowRight");
      updatePages(reader);
    }
  });

  updatePages(reader);
  updateProgressBar(reader);
  updateDisplay(reader);
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
  const wrapper = getWrapper(reader);
  const { currentPage } = reader.dataset;

  getPages(reader).forEach((element) => {
    element.classList.add("hidden");
    if (element.getAttribute("data-page") == currentPage) {
      element.classList.remove("hidden");
    }
  });

  if (formatOptions.scroll?.enabled) {
    wrapper.scrollTo({
      top: 0,
      behavior: formatOptions.scroll.behavior,
    });
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

function navigateToPage(reader, isLeft, isRight) {
  if (isLeft && canGoLeft(reader)) {
    previousPage(reader);
    dismissPopups(reader);
  } else if (isRight && canGoRight(reader)) {
    nextPage(reader);
    dismissPopups(reader);
  } else if (isRight && options.navigation.lastPage.goToNextManga) {
    // go to next page
    window.location.href = "/";
  }
}

function dismissPopups(reader) {
  reader.querySelectorAll('[data-role="toggle"]').forEach((element) => {
    const target =
      element.dataset.for && document.getElementById(element.dataset.for);
    if (target) {
      target.classList.add(element.dataset.class || "hidden");
      setTimeout(() => {
        target.classList.remove("z-10");
      }, 250);
    }
  });
}

function nextPage(reader) {
  const currentPage = parseInt(reader.dataset.currentPage);
  reader.dataset.currentPage = String(currentPage + 1);
}

function previousPage(reader) {
  const currentPage = parseInt(reader.dataset.currentPage);
  reader.dataset.currentPage = String(currentPage - 1);
}

function updateProgressBar(reader) {
  const progressBar = getProgressBar(reader);

  const pages = parseInt(reader.dataset.pages);
  const currentPage = parseInt(reader.dataset.currentPage);

  const newWidth = `${(currentPage * 100) / pages}%`;
  progressBar.style.width = newWidth;
}

function updateDisplay(reader) {
  reader.querySelectorAll("[data-display]").forEach((element) => {
    if (element.dataset.display === "current-page") {
      const { currentPage, pages } = reader.dataset;

      if (currentPage === "0") {
        element.innerHTML = "cover page";
      } else {
        element.innerHTML = `page ${currentPage} of ${pages}`;
      }
    }
  });
}

function unlazifyImage(reader, loadPagesCount = 3) {
  const currentPage = parseInt(reader.dataset.currentPage);
  const lastPage = parseInt(reader.dataset.pages) - 1;
  const pageToLoad = Math.min(loadPagesCount + currentPage, lastPage);

  document
    .querySelector(`[data-page="${pageToLoad}"] img`)
    .removeAttribute("loading");
}

function getReaderFormatOptions(reader) {
  const { format } = reader.dataset;

  return options.format[format] || options.format[options.format.default];
}

function getWrapper(reader) {
  return reader.querySelector("#wrapper");
}

function getContainer(reader) {
  return reader.querySelector("#container");
}

function getProgressBar(reader) {
  return reader.querySelector(".progress-bar");
}

function getPages(reader) {
  return reader.querySelectorAll("[data-page]");
}

function setClasses(node, classes) {
  if (classes.length) {
    node.classList.add(...classes);
  }
}
