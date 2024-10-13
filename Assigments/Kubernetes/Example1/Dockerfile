# use the node.js image
FROM node:14

# set the working directory
WORKDIR /usr/src/app 

# Copy package.json and install dependencies
COPY package.json . 
RUN npm install 

# copy the rest of the app code
COPY . . 

# expose port 3000
EXPOSE 3000 

# command to run the application 
CMD ["npm", "start"]
