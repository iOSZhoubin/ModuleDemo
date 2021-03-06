

/* vue修饰符
* model修饰符:  .number .lazy
* 按键修饰符:  .enter.ctrl.keyCode
* 事件修饰符: stopPropagation, cancelBubble=true
*             preventDefault, returnValue=false
*
* */


/*computed: 计算属性,不是方法
* 方法不会缓存数据
* 有两部分get和set(不能只有set方法)
* computed会根据依赖的(归vue管理的)数据进行缓存,可以实现响应式
* 不支持异步逻辑...
*
* */


/** 实现单页开发
 * 浏览器的history
 *
 * hash方式管理
 * */


/* watch 默认不能监控到数组内部元素的变化
*
* 若需要监控数组中每个元素的变化,需要使用深度watch方式
*
* 深度watch
* watch:{
*    todos:{   // 被监控的属性
*     handle(){   // 固定名称和写法
*
*    },deep:true
* }
*
* */

/** localStorage 默认存的是字符串 */