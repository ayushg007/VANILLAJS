"use strict";
const Utils = { 
    // --------------------------------
    //  Parse a url and break it into resource, id and verb
    // --------------------------------
    parseRequestURL : () => {

        let url = location.hash.slice(1).toLowerCase() || '/';
        let r = url.split("/")
        let request = {
            resource    : null,
            id          : null,
            verb        : null
        }
        request.resource    = r[1]
        request.id          = r[2]
        request.verb        = r[3]

        return request
    }

    // --------------------------------
    //  Simple sleep implementation
    // --------------------------------
    , sleep: (ms) => {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
}

let getInterview = async (id) => {
    const options = {
       method: 'GET',
       headers: {
           'Content-Type': 'application/json'
       }
   };
   try {
       console.log(id); 
       const response = await fetch(`http://localhost:3000/interviews/` + id, options)
       const json = await response.json();
       console.log(json)
       return json
   } catch (err) {
       console.log('Error getting documents', err)
   }
}

let InterviewShow = {
    render : async () => {
        let request = Utils.parseRequestURL()
        console.log(request);
        console.log(location.hash);
        let result = await getInterview(request.id);
        let interview=result.interview;
        let participants = result.participants;
        let participantsHTML="";
        for (let i=0;i<participants.length;++i){
            participantsHTML+="<p>Email id: "+ participants[i].email + " </p>"
            + "<p> Resume File: "+ participants[i].resume_file_name + "<p>";
        } 
        let delLink = "/#/interviews/"+interview.id+"/delete";
        let editLink= "/#/interviews/"+interview.id+"/edit";
        return /*html*/`
            <section class="section">
                
                <h1> Interview Title : ${interview.title} </h1>
                <p> Interview date : ${interview.date} </p>
                <p> Interview start : ${interview.start_time} </p>
                <p> Interview End : ${interview.end_time} </p>
            <h3> Participants </h3>`+participantsHTML+
            `  
            </section>
            <div>
            <a href="${editLink}"> Edit </a> ||
            <a href="${delLink}"> Delete </a>||
            <a href="#/home"> Back </a>
            </div>
        `
    }
    , after_render: async () => {
    }
}

let getInterviewsList = async () => {
    const options = {
       method: 'GET',
       headers: {
           'Content-Type': 'application/json'
       }
   };
   try {
       const response = await fetch(`http://localhost:3000/home`, options)
       const json = await response.json();
        console.log(json)
       return json
   } catch (err) {
       console.log('Error getting documents', err)
   }
}

let Home = {
    render : async () => {
        let interviews = await getInterviewsList()
        let view =  /*html*/`
            <section class="section">
                <h1> All Interviews </h1>
                <ul>
                    ${ interviews.map(interview => 
                        /*html*/`<li><a class="" href="#/interviews/${interview.id}">${interview.title}</a></li>`
                        ).join('\n ')
                    }
                </ul>
                <a href="/#/addnew">
                <strong>Add New</strong>
                </a>
            </section>
        `
        return view
    }
    , after_render: async () => {
    }

}

let create = async (interview,participants) => {
    const options = {
       method: 'POST',
       headers: {
           'Content-Type': 'application/json'
       },
       body: JSON.stringify({"interview" : interview , "p" : participants})
   };
   try {
       const response = await fetch(`http://localhost:3000/interviews`, options);
       alert("INTERVIEW CREATED");
       location.hash="/home";
   } catch (err) {
       console.log('Error getting documents', err)
   }
}

let Addnew = {

    render: async () => {
        return /*html*/ `
            <section class="section">
                <div class="field">
                
                    <p class="control has-icons-left has-icons-right">
                    Enter Title
                        <input class="input" id="title" type="" placeholder="Enter Title">
                        
                    </p>
                </div>
                <div class="field">
                    <p class="control has-icons-left">
                    Enter Date:
                        <input type="date" class="input" id="date" placeholder="Enter Date">
                        
                    </p>
                </div>
                <div class="field">
                    <p class="control has-icons-left">
                    Enter Start Time:
                        <input type="time" class="input" id="start_time"  placeholder="Enter Start Time">
                        
                    </p>
                </div>
                <div class="field">
                
                    <p class="control has-icons-left">
                    Enter End time:
                        <input class="input" type="time" id="end_time"  placeholder="Enter End time">
                        
                    </p>
                </div>
                <div class="field">
                
                    <p class="control has-icons-left">
                    Enter Participants:
                        <input class="input"  id="participants"  placeholder="Enter Participants">
                        
                    </p>
                </div>
                <div class="field">
                    <p class="control">
                    
                        <button class="button is-primary" id="submit_btn">
                        Add New
                        </button>
                    </p>
                </div>
                
            </section>
        `
    }
    // All the code related to DOM interactions and controls go in here.
    // This is a separate call as these can be registered only after the DOM has been painted
    , after_render: async () => {
        document.getElementById("submit_btn").addEventListener ("click",  () => {
            let title      = document.getElementById("title");
            let date        = document.getElementById("date");
            let start_time  = document.getElementById("start_time");
            let end_time  = document.getElementById("start_time");
            let participants  = document.getElementById("participants");
            let interview={"start_time":start_time.value,"end_time":end_time.value,"title":title.value,"date":date.value}
            create(interview,participants.value);
            
        })
    }
}

let deleteInterview = async (id) => {
    const options = {
       method: 'DELETE',
       headers: {
           'Content-Type': 'application/json'
       },
       
   };
   try {
       const response = await fetch(`http://localhost:3000/interviews/`+id, options);
       alert("INTERVIEW Deleted");
       location.hash="/home";
   } catch (err) {
       console.log('Error getting documents', err)
   }
}


const InterviewDelete = {
    render : async () => {
        let request = Utils.parseRequestURL();
        let interviews = await deleteInterview(request.id);

        let view =  /*html*/`
            <section class="section">
                INTERVIEW DELETED
            </section>
        `
        return view
    }
        , after_render: async () => {
        }
};

let update = async(interview,participants) => {
    let request = Utils.parseRequestURL();
    const options = {
        method: 'PATCH',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({"interview" : interview , "p" : participants})
    };
    try {
        const response = await fetch(`http://localhost:3000/interviews/`+request.id, options);
        alert("INTERVIEW UPDATED");
        location.hash="/home";
    } catch (err) {
        console.log('Error getting documents', err)
    }
}

let InterviewEdit = {

    render: async () => {
        let request = Utils.parseRequestURL()
        console.log(request);
        console.log(location.hash);
        let result = await getInterview(request.id);
        let interview=result.interview;
        let participants = result.participants;
        let participantsHTML="";
        return /*html*/ `
            <section class="section">
                <div class="field">
                
                    <p class="control has-icons-left has-icons-right">
                    Enter Title
                        <input class="input" id="title" type="" placeholder="Enter Title" value="${interview.title}">
                        
                    </p>
                </div>
                <div class="field">
                    <p class="control has-icons-left">
                    Enter Date:
                        <input type="date" class="input" id="date" placeholder="Enter Date" value="${interview.date}">
                        
                    </p>
                </div>
                <div class="field">
                    <p class="control has-icons-left">
                    Enter Start Time:
                        <input type="time" class="input" id="start_time"  placeholder="Enter Start Time" value="${interview.start_time}"> 
                        
                    </p>
                </div>
                <div class="field">
                
                    <p class="control has-icons-left">
                    Enter End time:
                        <input class="input" type="time" id="end_time"  placeholder="Enter End time" value="${interview.end_time}">
                        
                    </p>
                </div>
                <div class="field">
                
                    <p class="control has-icons-left">
                    Enter Participants:
                        <input class="input"  id="participants"  placeholder="Enter Participants">
                        
                    </p>
                </div>
                <div class="field">
                    <p class="control">
                    
                        <button class="button is-primary" id="submit_btn">
                        Update
                        </button>
                    </p>
                </div>
                
            </section>
        `
    }
    , after_render: async () => {
        document.getElementById("submit_btn").addEventListener ("click",  () => {
            let title      = document.getElementById("title");
            let date        = document.getElementById("date");
            let start_time  = document.getElementById("start_time");
            let end_time  = document.getElementById("start_time");
            let participants  = document.getElementById("participants");
            let interview={"start_time":start_time.value,"end_time":end_time.value,"title":title.value,"date":date.value};
            update(interview,participants.value);
        }
        )
    }
}
// List of supported routes. Any url other than these routes will throw a 404 error
const routes = {
    
    '/interviews/:id'      : InterviewShow,
    '/interviews/:id/edit' : InterviewEdit,
    '/home'    : Home,
    '/addnew' : Addnew,
    '/interviews/:id/delete' : InterviewDelete
};


// The router code. Takes a URL, checks against the list of supported routes and then renders the corresponding content page.
const router = async () => {

    // Lazy load view element:
    const content = null || document.getElementById('page_container');
    
    // Get the parsed URl from the addressbar
    let request = Utils.parseRequestURL()

    // Parse the URL and if it has an id part, change it with the string ":id"
    let parsedURL = (request.resource ? '/' + request.resource : '/') + (request.id ? '/:id' : '') + (request.verb ? '/' + request.verb : '')
    console.log(request.resource);
    // Get the page from our hash of supported routes.
    // If the parsed URL is not in our list of supported routes, select the 404 page instead
    let page = routes[parsedURL] ? routes[parsedURL] : Error404
    content.innerHTML = await page.render();
    await page.after_render();
  
}

// Listen on hash change:
window.addEventListener('hashchange', (event) => {
    console.log('hashchanged');
    router(event);
});

// Listen on page load:
window.addEventListener('load', router);



